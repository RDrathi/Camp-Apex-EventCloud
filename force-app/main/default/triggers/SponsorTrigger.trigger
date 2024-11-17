trigger SponsorTrigger on CAMPX__Sponsor__c(before insert, before update) {
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
