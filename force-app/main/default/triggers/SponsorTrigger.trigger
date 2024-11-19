trigger SponsorTrigger on CAMPX__Sponsor__c(
  before insert,
  before update,
  after insert,
  after update,
  after delete,
  after undelete
) {
  if (
    Trigger.isAfter &&
    (Trigger.isInsert ||
    Trigger.isUpdate ||
    Trigger.isUndelete)
  ) {
    SponsorTriggerHandler.updateEventGross(Trigger.new);
  }
  if (Trigger.isAfter && Trigger.isDelete) {
    SponsorTriggerHandler.updateEventGross(Trigger.old);
  }

  if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
    for (CAMPX__Sponsor__c sponsor : Trigger.new) {
      if (String.isBlank(sponsor.CAMPX__Status__c)) {
        sponsor.CAMPX__Status__c = 'Pending';
      }

      if (
        0 < sponsor.CAMPX__ContributionAmount__c &&
        sponsor.CAMPX__ContributionAmount__c < 1000
      ) {
        sponsor.CAMPX__Tier__c = 'Bronze';
      } else if (
        1000 <= sponsor.CAMPX__ContributionAmount__c &&
        sponsor.CAMPX__ContributionAmount__c < 5000
      ) {
        sponsor.CAMPX__Tier__c = 'Silver';
      } else if (sponsor.CAMPX__ContributionAmount__c >= 5000) {
        sponsor.CAMPX__Tier__c = 'Gold';
      }

      if (
        sponsor.CAMPX__Status__c == 'Accepted' &&
        sponsor.CAMPX__Event__c == null
      ) {
        sponsor.addError(
          'A Sponsor must be associated with an event before being Accepted.'
        );
      }
    }
  }
}
