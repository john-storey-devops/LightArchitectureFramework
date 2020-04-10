@IsTest
public class AccountSpecialTest {
    
    @IsTest
    private static void TriggerUsage_ValidRecord() {

        Account acct = new Account();
        acct.Name = 'joe';
        acct.Description = 'a colloquialism for coffee';

        insert acct;
        // No assert needed since successful insertion is sufficient.
    }
    
    @IsTest
    private static void TriggerUsage_InvalidRecord() {

        Account acct = new Account();
        acct.Name = 'joe';
        // acct.Description = 'a colloquialism for coffee';

        try {
            insert acct;
            System.assert(false);  // An exception is expected.
        }
        catch (Exception exc) {
            // An exception is expected.
        }
    }

    @IsTest
    private static void MockDomainUsage() {

        Account acct = new Account();
        acct.Name = 'joe';
        // acct.Description = 'a colloquialism for coffee';

        Application.Domain.setMock(Account.SObjectType, new MockAccountDomain());

        // The following insert will not generate an exception because the 
        // Application factory will supply the mock domain which does not
        // implement any validation.
        ((IAccountDomain) Application.Domain.newInstance(Account.SObjectType)).validate(new List<Account> {acct});
    }

    @IsTest
    private static void MockSelectorUsage() {

        // Verify that no Account records exist within the test context.
        System.assertEquals(0, [select id from Account].size());

        Account acct = new Account();
        acct.Name = 'joe';

        MockAccountSelector mock = new MockAccountSelector();
        mock.accountList = new List<Account> {acct};

        Application.Selector.setMock(Account.SObjectType, mock);

        // Even though we're supplying an empty Set<Id> ...
        List<Account> accountList = ((IAccountSelector) Application.Selector.newInstance(Account.SObjectType)).selectById(new Set<Id>());

        // ... we get back the data that we gave to the mock class.
        System.assertEquals(1, accountList.size());
        System.assertEquals(acct.Name, accountList.get(0).Name);
    }

    private class MockAccountDomain
        implements IAccountDomain {

        public SObjectType domainSObjectType() {
            return Account.SObjectType;
        }

        public MockAccountDomain newInstance() {
            return this;
        }

        public void validate(List<Account> accountList) {
            // Intentionally blank.
        }
    }

    private class MockAccountSelector
        implements IAccountSelector {

        public List<Account> accountList = null;

        public SObjectType sObjectType() {
            return Account.SObjectType;
        }

        public String getFieldsToQuery() {
            return '';
        }
    
        public List<SObject> selectSObjectById(Set<Id> idSet) {
            return accountList;
        }
    
        public List<Account> selectById(Set<Id> idSet) {
            return accountList;
        }

        public List<Account> selectByNameContains(String search_text) {
            return accountList;
        }
    }
}
