public abstract class TriggerHandlerAbstract  {

    protected Boolean isExecuting = false;
    protected Boolean isBefore = false;
    protected Boolean isAfter = false;
    protected Boolean isInsert = false;
    protected Boolean isUpdate = false;
    protected Boolean isDelete = false;

    protected List<SObject> newSObjectList = null;
    protected Map<Id, SObject> oldSObjectMap = null;

    protected void setTriggerContext() {
        isExecuting = Trigger.isExecuting;
        isBefore = Trigger.isBefore;
        isAfter = Trigger.isAfter;
        isInsert = Trigger.isInsert;
        isUpdate = Trigger.isUpdate;
        isDelete = Trigger.isDelete;

        newSObjectList = Trigger.new;
        oldSObjectMap = Trigger.oldMap;
    }

    public abstract void handleTrigger();

    public class TriggerHandlerAbstractException
        extends Exception {}
}
