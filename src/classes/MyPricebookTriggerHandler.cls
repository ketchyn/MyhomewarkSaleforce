public with sharing class MyPricebookTriggerHandler {
	public MyPricebookTriggerHandler() {
		
	}

	private static List<MyPricebook__c> oldValues=new List<MyPricebook__c>();
	private static boolean isfutureupdate = false;

	
   // checking whether trigger fires first or second time, its just because I set 
   //after insert update, so trigger.new values have been already inserted, and i need to
   // query inserted values one more time and make changes and insert/update them again which will also launch trigger again
	private static  void checkIfFirstUpdate(List<MyPricebook__c> CurrentValus){

	if(oldValues.equals(CurrentValus)) isfutureupdate=true;
	else isfutureupdate=false;

	}


	public static void handleInsert(List<MyPricebook__c> newPricebook){

			//retrieve book which we hava just inserted
		Map<Id,MyPricebook__c> toupdateBooks =  new Map<Id,MyPricebook__c>([select id, status__c, Account__c, model__c
			from MyPricebook__c where id in :newPricebook]
																	);																
          
		for(MyPricebook__c book:toupdateBooks.values() ){

			if(book.Account__r.id!=null){
				book.status__c='soled';
			   System.debug( 'book akk id' +book.Account__c);

			}else book.status__c='new';
			   
			   
		}
		 update toupdateBooks.values();
		 UpdateAuto(toupdateBooks);

	}
			

		public static void  handleUpdate(List<MyPricebook__c> newPricebook,List<MyPricebook__c> oldPricebook){

			//retrieve book which we have just inserted
		Map<Id,MyPricebook__c> curentBooks =  new Map<Id,MyPricebook__c>([select id, name, status__c, model__c,
			 Account__c
			from MyPricebook__c where id in :newPricebook]

																											);
			System.debug(' currentbook ' + curentBooks.values()[0].Account__c);

		List<MyPricebook__c> toupdateBooks =new List<MyPricebook__c>();
		//check whether first time trigger was launched or not 
		 checkIfFirstUpdate(curentBooks.values());
        // making changes only on first launch
        if(isfutureupdate==false){

		for(Integer i =0; i<newPricebook.size();i++){

			if(oldPricebook.get(i).Account__c!=null){
                    //compare old and new values, if owner was changed we make changes 
				if(!oldPricebook.get(i).Account__c.equals(newPricebook.get(i).Account__c)){
						System.debug( ' currentbook' + ' ' + curentBooks.get(newPricebook.get(i).id));
					MyPricebook__c tuUp= curentBooks.get(newPricebook.get(i).id);

					tuUp.status__c='used';
					toupdateBooks.add(tuUp);
					

				}
			}
		}
		System.debug('tu updatebooks '+ toupdateBooks + ' ');
		System.debug('old' + ' '+ oldPricebook);
		System.debug('new ' + newPricebook);
	      

		oldValues=toupdateBooks;

			 update toupdateBooks;
			 UpdateAuto(curentBooks);

		}
		
	}

		private static void UpdateAuto(Map<Id,MyPricebook__c> book){


		
			Map<String,String> modelToAccount = new Map<String,String>();
			


			for(MyPricebook__c b:book.values()){

				modelToAccount.put(b.model__c, b.Account__c);
				System.debug('accountINUpdateAuto ' + b.Account__c);
			}   
			// машины котрые надо апдейтить,  вытаскиваем по признаку равенства модели из прайзбука

			List<Auto__c> AutoToUpdate = [select Account__c, model__c from Auto__c where model__c in:modelToAccount.keySet()];


              // для кажой машины берем прайзбук модель которого такая же как у тикущей машины 
              // и проставляем владельца как и возвращенного прайзбука   
			for(Auto__c auto:AutoToUpdate ){
				auto.Account__c=modelToAccount.get(auto.model__c); 
			}
			update AutoToUpdate;

		}
}
