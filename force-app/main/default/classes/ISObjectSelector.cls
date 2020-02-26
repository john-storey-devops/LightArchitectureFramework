public interface ISObjectSelector {
    SObjectType sObjectType();
    List<SObject> selectSObjectById(Set<Id> idSet);
}
