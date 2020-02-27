public abstract class TriggerHandlerAbstract
    implements ITriggerHandler {

    protected Boolean isExecuting = false;
    protected Boolean isBefore = false;
    protected Boolean isAfter = false;
    protected Boolean isInsert = false;
    protected Boolean isUpdate = false;
    protected Boolean isDelete = false;

    protected List<SObject> newSObjectList = null;
    protected Map<Id, SObject> newSObjectMap = null;
    protected List<SObject> oldSObjectList = null;
    protected Map<Id, SObject> oldSObjectMap = null;

    protected Integer size = -1;

    protected void setTriggerContext() {
        isExecuting = Trigger.isExecuting;
        isBefore = Trigger.isBefore;
        isAfter = Trigger.isAfter;
        isInsert = Trigger.isInsert;
        isUpdate = Trigger.isUpdate;
        isDelete = Trigger.isDelete;

        newSObjectList = Trigger.new;
        newSObjectMap = Trigger.newMap;
        oldSObjectList = Trigger.old;
        oldSObjectMap = Trigger.oldMap;

        size = Trigger.size;
    }

    public abstract void handleTrigger();

    public class TriggerHandlerAbstractException
        extends Exception {}
}
