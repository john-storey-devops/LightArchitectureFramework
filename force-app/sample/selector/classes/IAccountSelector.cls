public interface IAccountSelector
    extends ISObjectSelector {
    
    IAccountSelector addAdditionalSObjectFields(List<Schema.SObjectField> additionalFields);
    List<Account> selectById(Set<Id> idSet);
    List<Account> selectByNameContains(String search_text);
}
