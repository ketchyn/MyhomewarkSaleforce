trigger GCTrigger on GC__c (before insert, before update) {

	/*
		C__c parent  = [select id, MSgFromChild__c from C__c where id = :trigger.new[0].C__C limit 1];
		if(parent!=null){
			String msg = 
			parent.MSgFromChild__c = trigger.new[0].MSgFromChild__c;
			Update parent;
		}
*/

       
       
        
	

}