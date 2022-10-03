public interface IUnitOfWork
{
	List<Object> commitWork();
	UnitOfWorkArtifacts.DmlOperation getDmlOperation();
	SObjectType getSObjectType();
	void register(SObject item);
	void register(List<SObject> items);
}