@IsTest
public class AccountDomainTest {

    @IsTest
    private static void createNewInstance() {

        IAccountDomain dom = AccountDomain.newInstance();
        Assert.isNotNull(dom);
        Assert.areEqual(Account.SObjectType, dom.domainSObjectType());
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
            Assert.fail();
        }
        catch (Exception exc) {
            // This is expected.
        }
    }

    public class mock_AccountSelector
        implements IAccountSelector {

        public SObjectType sobjectType() {
            return Account.SObjectType;
        }

        public String getFieldsToQuery() {
            return '';
        }

        public IAccountSelector addAdditionalSObjectFields(List<SObjectField> additionalFields) {
            return this;
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