public class DoNothingDomainClass
    implements IDomain, ITriggerHandler {

    public static IDomain newInstance() {
        return new DoNothingDomainClass();
    }

    public void handleTrigger() {
        // Intentionally blank.
    }

    public SObjectType domainSObjectType() {
        return null;
    }
}
