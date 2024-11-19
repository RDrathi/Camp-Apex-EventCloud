public with sharing class SponsorTriggerHandler {
  public static void updateEventGross(
    List<CAMPX__Sponsor__c> sponsorListReceived
  ) {
    //set to IDs to store the unique event Ids
    Set<Id> eventIdSet = new Set<Id>();

    if (Trigger.isInsert || Trigger.isUndelete) {
      for (CAMPX__Sponsor__c sponsor : sponsorListReceived) {
        if (sponsor.CAMPX__Status__c == 'Accepted') {
          eventIdSet.add(sponsor.CAMPX__Event__c);
        }
      }
    }

    if (Trigger.isUpdate) {
      for (CAMPX__Sponsor__c newSponsor : sponsorListReceived) {
        CAMPX__Sponsor__c oldSponsor = (CAMPX__Sponsor__c) Trigger.oldMap
          .get(newSponsor.Id);
        if (oldSponsor.CAMPX__Status__c != newSponsor.CAMPX__Status__c) {
          eventIdSet.add(newSponsor.CAMPX__Event__c);
        }
      }
    }

    if (Trigger.isDelete) {
      for (CAMPX__Sponsor__c oldSponsor : sponsorListReceived) {
        if (oldSponsor.CAMPX__Status__c == 'Accepted') {
          eventIdSet.add(oldSponsor.CAMPX__Event__c);
        }
      }
    }

    if (!eventIdSet.isEmpty()) {
      List<CAMPX__Event__c> eventsToUpdate = new List<CAMPX__Event__c>();

      Map<Id, AggregateResult> eventIdGrossMap = new Map<Id, AggregateResult>();

      List<AggregateResult> grossRevList = [
        SELECT
          CAMPX__Event__c eventId,
          SUM(CAMPX__ContributionAmount__c) AmountSum
        FROM CAMPX__Sponsor__c
        WHERE CAMPX__Event__c IN :eventIdSet AND CAMPX__Status__c = 'Accepted'
        GROUP BY CAMPX__Event__c
      ];
      for (AggregateResult agrRes : grossRevList) {
        eventIdGrossMap.put((Id) agrRes.get('eventId'), agrRes);
      }
      for (Id eventId : eventIdSet) {
        CAMPX__Event__c eventRec = new CAMPX__Event__c(Id = eventId);
        AggregateResult result = eventIdGrossMap.get(eventId);
        if (result != null) {
          eventRec.CAMPX__GrossRevenue__c = (Decimal) result.get('AmountSum');
        } else {
          eventRec.CAMPX__GrossRevenue__c = 0;
        }
        eventsToUpdate.add(eventRec);
      }
      if (!eventsToUpdate.isEmpty()) {
        update eventsToUpdate;
      }
    }
  }
}
