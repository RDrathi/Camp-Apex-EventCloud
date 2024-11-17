trigger EventTrigger on CAMPX__Event__c(before insert, before update) {
  if (Trigger.isBefore && Trigger.isInsert) {
    EventTriggerHandler.updateNetRevenue(Trigger.new);
    for (CAMPX__Event__c event : Trigger.new) {
      event.CAMPX__Status__c = 'Planning';
      event.CAMPX__StatusChangeDate__c = Datetime.Now();
    }
  }

  if (Trigger.isBefore && Trigger.isUpdate) {
    EventTriggerHandler.updateNetRevenue(Trigger.new);
    for (CAMPX__Event__c newEvent : Trigger.new) {
      CAMPX__Event__c oldEvent = Trigger.oldMap.get(newEvent.Id);
      if (newEvent.CAMPX__Status__c != oldEvent.CAMPX__Status__c) {
        newEvent.CAMPX__StatusChangeDate__c = DateTime.now();
      }
    }
  }
}
