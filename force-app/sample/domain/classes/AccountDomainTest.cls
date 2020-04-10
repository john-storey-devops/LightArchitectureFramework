@IsTest
public class AccountDomainTest {

    @IsTest
    private static void createNewInstance() {

        IAccountDomain dom = AccountDomain.newInstance();
        System.assert(dom != null);
        System.assertEquals(Account.SObjectType, dom.domainSObjectType());
    }

    @IsTest
    private static void Validation_PositiveCase() {

        Account acct = new Account();
        acct.Name = 'joe';
        acct.Description = 'a colloquialism for coffee';

        new AccountDomain().validate(new List<Account> {acct});
    }

    @IsTest
    private static void Validation_NegativeCase() {

        Account acct = new Account();
        acct.Name = 'joe';
        acct.Description = '';

        try {
            new AccountDomain().validate(new List<Account> {acct});
            System.assert(false);
        }
        catch (Exception exc) {
            // This is expected.
        }
    }

    public class mock_AccountSelector
        implements IAccountSelector {

        public SObjectType sObjectType() {
            return Account.SObjectType;
        }

        public String getFieldsToQuery() {
            return '';
        }

        public List<SObject> selectSObjectById(Set<Id> idSet) {
            return list_to_return;
        }
    
        public List<Account> selectById(Set<Id> idSet) {
            return list_to_return;
        }

        public List<Account> selectByNameContains(String search_text) {
            return list_to_return;
        }

        public List<Account> list_to_return = null;
    }
}