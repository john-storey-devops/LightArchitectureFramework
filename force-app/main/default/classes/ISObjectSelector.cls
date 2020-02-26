public interface ISObjectSelector {
    SObjectType sObjectType();
    List<SObject> selectSObjectById();
}
