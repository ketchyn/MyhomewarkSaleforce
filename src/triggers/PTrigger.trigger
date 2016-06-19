trigger PTrigger on P__c (before insert,before update) {



	/*	GP__c parent  = [select id, MSgFromChild__c from GP__c where id =: trigger.new[0].GP__C limit 1];
		if(parent!=null){
			parent.MSgFromChild__c = trigger.new[0].MSgFromChild__c;
			Update parent;
		}*/


      
		C__c child  = [select id, MSgFromChild__c from C__c where P__c = :trigger.new[0].id  limit 1];



        if(child!=null){
			Datetime d = Datetime.now();
			child.MSgFromChild__c =    '//' + 'msg from Parent '+ '//' + trigger.new[0].MSgFromChild__c +' ' + d ; 
			Update child;
		}
         

}