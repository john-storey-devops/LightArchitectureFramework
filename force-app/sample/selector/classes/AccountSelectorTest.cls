@IsTest
public class AccountSelectorTest {
    
    @IsTest
    private static void InertUsage() {
        IAccountSelector sel = AccountSelector.newInstance();
        Assert.isNotNull(sel);
        Assert.areEqual(Account.SObjectType, sel.sobjectType());
    }

    @IsTest
    private static void SelectById_IdSetIsEmpty() {
        List<Account> accountList = AccountSelector.newInstance()
                .addAdditionalSObjectFields(new List<SObjectField> {Account.OwnerId})
                .selectById(new Set<Id>());
        Assert.isNotNull(accountList);
        Assert.isTrue(accountList.isEmpty());
    }

    @IsTest
    private static void SelectById_AbsentRecord() {
        Id mock_id = Account.SObjectType.getDescribe().getKeyPrefix() + '000000000001';
        List<Account> accountList = AccountSelector.newInstance().selectById(new Set<Id>{mock_id});
        Assert.isNotNull(accountList);
        Assert.isTrue(accountList.isEmpty());
    }

    @IsTest
    private static void SelectByNameContains_SearchTextIsBlank() {
        List<Account> accountList = AccountSelector.newInstance().selectByNameContains('');
        Assert.isNotNull(accountList);
        Assert.isTrue(accountList.isEmpty());
    }
}
