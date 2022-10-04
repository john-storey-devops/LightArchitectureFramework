public interface IContactSelector
	extends ISObjectSelector
{
	List<Contact> selectById(Set<Id> idSet);
}
