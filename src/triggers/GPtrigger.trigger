trigger GPtrigger on GP__C (before insert, before update) {


      
		P__c child  = [select id, MSgFromChild__c from P__c where GP__c = :trigger.new[0].id  limit 1];



        if(child!=null){
			Datetime d = Datetime.now();
			child.MSgFromChild__c =    '//' + 'msg from Parent '+ '//' + trigger.new[0].MSgFromChild__c +' ' + d ; 
			Update child;
		}

}