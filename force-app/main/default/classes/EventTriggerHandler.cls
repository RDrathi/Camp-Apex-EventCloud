public with sharing class EventTriggerHandler {
  public static void updateNetRevenue(List<CAMPX__Event__c> newEventList) {
    for (CAMPX__Event__c event : newEventList) {
      if (
        event.CAMPX__GrossRevenue__c == null ||
        event.CAMPX__TotalExpenses__c == null
      ) {
        event.CAMPX__NetRevenue__c = null;
      } else {
        event.CAMPX__NetRevenue__c =
          event.CAMPX__GrossRevenue__c - event.CAMPX__TotalExpenses__c;
      }
    }
  }
}
