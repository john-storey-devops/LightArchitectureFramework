@IsTest
public class ContactSelectorTest {
    
    @IsTest
    private static void InertUsage() {
        IContactSelector sel = ContactSelector.newInstance();
        Assert.isNotNull(sel);
        Assert.areEqual(Contact.SObjectType, sel.sObjectType());
    }

    @IsTest
    private static void SelectById_IdSetIsEmpty() {
        List<Contact> contactList = ContactSelector.newInstance()
                .addAdditionalSObjectFields(new List<Schema.SObjectField> {Contact.OwnerId})
                .selectById(new Set<Id>());
        Assert.isNotNull(contactList);
        Assert.isTrue(contactList.isEmpty());
    }

    @IsTest
    private static void SelectById_AbsentRecord() {
        Id mock_id = Contact.SObjectType.getDescribe().getKeyPrefix() + '000000000001';
        List<Contact> contactList = ContactSelector.newInstance().selectById(new Set<Id>{mock_id});
        Assert.isNotNull(contactList);
        Assert.isTrue(contactList.isEmpty());
    }
}
