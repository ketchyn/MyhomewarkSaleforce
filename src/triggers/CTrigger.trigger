trigger CTrigger on C__c (before insert, before update) {

		/*P__c parent  = [select id, MSgFromChild__c from P__c where id = :trigger.new[0].P__C limit 1];
		if(parent!=null){
			Datetime d = Datetime.now();
			parent.MSgFromChild__c =     'msg from child ' + trigger.new[0].MSgFromChild__c +' ' + d;
			Update parent;
		}
*/

		GC__c child  = [select id, MSgFromChild__c from GC__c where C__c = :trigger.new[0].id  limit 1];



        if(child!=null){
			Datetime d = Datetime.now();
			child.MSgFromChild__c =    '//' + 'msg from Parent '+ '//' + trigger.new[0].MSgFromChild__c +' ' + d ; 
			Update child;
		}
         
      

}