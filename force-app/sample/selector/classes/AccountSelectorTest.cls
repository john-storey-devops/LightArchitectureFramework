@IsTest
public class AccountSelectorTest {
    
    @IsTest
    private static void InertUsage() {
        IAccountSelector sel = AccountSelector.newInstance();
        System.assert(sel != null);
        System.assertEquals(Account.SObjectType, sel.sObjectType());
    }

    @IsTest
    private static void SelectById_IdSetIsEmpty() {
        List<Account> accountList = AccountSelector.newInstance().selectById(new Set<Id>());
        System.assert(accountList != null);
        System.assert(accountList.isEmpty());
    }

    @IsTest
    private static void SelectById_AbsentRecord() {
        Id mock_id = Account.SObjectType.getDescribe().getKeyPrefix() + '000000000001';
        List<Account> accountList = AccountSelector.newInstance().selectById(new Set<Id>{mock_id});
        System.assert(accountList != null);
        System.assert(accountList.isEmpty());
    }

    @IsTest
    private static void SelectByNameContains_SearchTextIsBlank() {
        List<Account> accountList = AccountSelector.newInstance().selectByNameContains('');
        System.assert(accountList != null);
        System.assert(accountList.isEmpty());
    }
}
