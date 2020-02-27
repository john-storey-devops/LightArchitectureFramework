@IsTest
public class AccountSelectorTest {
    
    @IsTest
    private static void InertUsage() {
        IAccountSelector sel = AccountSelector.newInstance();
        System.assert(sel != null);
        System.assertEquals(Account.SObjectType, sel.sObjectType());
    }

    @IsTest
    private static void SelectSObjectById_IdSetIsEmpty() {
        Id mock_id = Account.SObjectType.getDescribe().getKeyPrefix() + '000000000001';
        List<SObject> sobjectList = AccountSelector.newInstance().selectSObjectById(new Set<Id>{mock_id});
        System.assert(sobjectList != null);
        System.assert(sobjectList.isEmpty());
    }

    @IsTest
    private static void SelectById_IdSetIsEmpty() {
        List<Account> accountList = AccountSelector.newInstance().selectById(new Set<Id>());
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
