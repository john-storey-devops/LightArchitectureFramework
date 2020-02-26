public class AccountDomain
    extends TriggerHandlerAbstract
    implements IAccountDomain, ITriggerHandler, IDomain {

    public static IAccountDomain newInstance() {
        return (IAccountDomain) Application.Domain.newInstance(Account.SObjectType);
    }

    public static SObjectType domainSObjectType() {
        return Account.SObjectType;
    }

    private List<Account> getNewAccountList() {
        return (List<Account>) newSObjectList;
    }

    private Map<Id, Account> getOldAccountList() {
        return (Map<Id, Account>) oldSObjectMap;
    }

    public override void handleTrigger() {

        setTriggerContext();

        if (isBefore && isInsert || isBefore && isUpdate) {
            validate(getNewAccountList());
        }
    }

    public void validate(List<Account> accountList) {

        for (Account acct : accountList) {
            if (String.isBlank(acct.Description)) {
                throw new AccountDomainException('Description is required.');
            }
        }
    }

    public class AccountDomainException
        extends Exception {
        // Intentionally blank.
    }
}
