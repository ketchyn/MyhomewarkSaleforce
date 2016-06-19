trigger MyPricebookTrigger on MyPricebook__c (after insert,after update) {
	if(Trigger.isInsert){

		 MyPricebookTriggerHandler.handleInsert(Trigger.new);
	}

	if(Trigger.isUpdate){
		
		 MyPricebookTriggerHandler.handleUpdate(Trigger.new, Trigger.old);
	}

}