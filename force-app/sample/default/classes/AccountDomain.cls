public class AccountDomain
    extends TriggerHandlerAbstract
    implements IAccountDomain {

    private List<Account> getNewAccountList() {
        return (List<Account>) newSObjectList;
    }

    private Map<Id, Account> getOldAccountList() {
        return (Map<Id, Account>) oldSObjectMap;
    }

    public override void handleTrigger() {

        if (isBefore && isInsert || isBefore && isUpdate) {
            validate(getNewAccountList());
        }
    }

    public static ITriggerHandler newTriggerInstance() {
        AccountDomain dom = new AccountDomain();
        dom.setTriggerContext();
        return dom;
    }

    public void validate() {
        validate(getNewAccountList());
    }

    public void validate(List<Account> accountList) {

        for (Account acct : accountList) {
            if (String.isBlank(acct.Description)) {
                throw new AccountDomainException('Description is required.');
            }
        }
    }

    public class AccountDomainException
        extends exception {
        // Intentionally blank.
    }
}
