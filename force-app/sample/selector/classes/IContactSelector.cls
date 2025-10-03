public interface IContactSelector
	extends ISObjectSelector
{
    IContactSelector addAdditionalSObjectFields(List<Schema.SObjectField> additionalFields);
	List<Contact> selectById(Set<Id> idSet);
    List<Contact> selectWithInjectable(Type injectableClassType, ISelectorArgumentable arguments);
}
