public virtual class TriggerHandlerAbstract
    implements ITriggerHandler {

    protected Boolean isBefore = false;
    protected Boolean isAfter = false;
    protected Boolean isInsert = false;
    protected Boolean isUpdate = false;
    protected Boolean isDelete = false;

    protected List<SObject> newSObjectList = null;
    protected Map<Id, SObject> oldSObjectMap = null;

    protected void setTriggerContext() {
        isBefore = Trigger.isBefore;
        isAfter = Trigger.isAfter;
        isInsert = Trigger.isInsert;
        isUpdate = Trigger.isUpdate;
        isDelete = Trigger.isDelete;

        newSObjectList = Trigger.new;
        oldSObjectMap = Trigger.oldMap;
    }

    public virtual void handleTrigger() {
        throw new TriggerHandlerAbstractException('Must be implemented by the extending class.');
    }

    public virtual ITriggerHandler newTriggerInstance() {
        throw new TriggerHandlerAbstractException('Must be implemented by the extending class.');
    }

    @TestVisible
    private void setTriggerContext(MockTriggerContext mock_trigger_context) {
        isBefore = mock_trigger_context.isBefore;
        isAfter = mock_trigger_context.isAfter;
        isInsert = mock_trigger_context.isInsert;
        isUpdate = mock_trigger_context.isUpdate;
        isDelete = mock_trigger_context.isDelete;

        newSObjectList = mock_trigger_context.newSObjectList;
        oldSObjectMap = mock_trigger_context.oldSObjectMap;
    }

    @TestVisible
    private class MockTriggerContext {
        public Boolean isBefore = false;
        public Boolean isAfter = false;
        public Boolean isInsert = false;
        public Boolean isUpdate = false;
        public Boolean isDelete = false;

        public List<Account> newSObjectList = null;
        public Map<Id, Account> oldSObjectMap = null;
    }

    public class TriggerHandlerAbstractException
        extends Exception {}
}
