public interface IAccountSelector
    extends ISObjectSelector {
    
    List<Account> selectById(Set<Id> idSet);
    List<Account> selectByNameContains(String search_text);
}
