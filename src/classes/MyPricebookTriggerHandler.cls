public with sharing class MyPricebookTriggerHandler {
	public MyPricebookTriggerHandler() {
		
	}

	private static List<MyPricebook__c> oldValues=new List<MyPricebook__c>();
	private static boolean isfutureupdate = false;

	private static  void checkIfFirstUpdate(List<MyPricebook__c> CurrentValus){

	if(oldValues.equals(CurrentValus)) isfutureupdate=true;
	else isfutureupdate=false;

	}

	public static void handleInsert(List<MyPricebook__c> newPricebook){
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
		Map<Id,MyPricebook__c> curentBooks =  new Map<Id,MyPricebook__c>([select id, name, status__c, model__c,
			 Account__c
			from MyPricebook__c where id in :newPricebook]

																											);
			System.debug(' currentbook ' + curentBooks.values()[0].Account__c);

		List<MyPricebook__c> toupdateBooks =new List<MyPricebook__c>();
		 checkIfFirstUpdate(curentBooks.values());

        if(isfutureupdate==false){

		for(Integer i =0; i<newPricebook.size();i++){
			
			if(oldPricebook.get(i).Account__c!=null){

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
			List<String> models = new List<String>();
			Map<String,String> modelToAccount = new Map<String,String>();
			


			for(MyPricebook__c b:book.values()){

				modelToAccount.put(b.model__c, b.Account__c);
				System.debug('accountINUpdateAuto ' + b.Account__c);
			} 

			List<Auto__c> AutoToUpdate = [select Account__c, model__c from Auto__c where model__c in:modelToAccount.keySet()];

			for(Auto__c auto:AutoToUpdate ){
				auto.Account__c=modelToAccount.get(auto.model__c); 
			}
			update AutoToUpdate;

		}
}