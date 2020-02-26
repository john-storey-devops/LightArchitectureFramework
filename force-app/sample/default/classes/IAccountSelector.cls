public interface IAccountSelector
    extends ISObjectSelector {
    
    List<Account> selectById(Set<Id> idSet);
    List<Account> selectNameContains(String search_text);
}
