public abstract class TriggerHandlerAbstract
    implements ITriggerHandler {

    protected Boolean isExecuting = false;
    protected Boolean isBefore = false;
    protected Boolean isAfter = false;
    protected Boolean isInsert = false;
    protected Boolean isUpdate = false;
    protected Boolean isDelete = false;

    protected List<SObject> newSObjectList = new List<SObject>();
    protected Map<Id, SObject> newSObjectMap = new Map<Id, SObject>();
    protected List<SObject> oldSObjectList = new List<SObject>();
    protected Map<Id, SObject> oldSObjectMap = new Map<Id, SObject>();

    protected Integer size = -1;

    protected void setTriggerContext() {
        isExecuting = getBooleanValue(Trigger.isExecuting);
        isBefore = getBooleanValue(Trigger.isBefore);
        isAfter = getBooleanValue(Trigger.isAfter);
        isInsert = getBooleanValue(Trigger.isInsert);
        isUpdate = getBooleanValue(Trigger.isUpdate);
        isDelete = getBooleanValue(Trigger.isDelete);

        newSObjectList = (Trigger.new != null) ? Trigger.new : newSObjectList;
        newSObjectMap = (Trigger.newMap != null) ? Trigger.newMap : newSObjectMap;
        oldSObjectList = (Trigger.old != null) ? Trigger.old : oldSObjectList;
        oldSObjectMap = (Trigger.oldMap != null) ? Trigger.oldMap : oldSObjectMap;

        size = (Trigger.size != null) ? Trigger.size : size;
    }

    public abstract void handleTrigger();

    private static Boolean getBooleanValue(Object obj)
    {
        if (obj == null)
        {
            return false;
        }
        return Boolean.valueOf(obj);
    }

    public class TriggerHandlerAbstractException
        extends Exception {}
}
