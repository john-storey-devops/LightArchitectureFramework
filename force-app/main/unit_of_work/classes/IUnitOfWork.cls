public interface IUnitOfWork
{
	List<Object> commitWork();
	DmlOperations.DMLOPERATION getDmlOperation();
	SObjectType getSObjectType();
	void registerDelete(SObject item);
	void registerDelete(List<SObject> items);
	void registerDirty(SObject item);
	void registerDirty(List<SObject> items);
	void registerNew(SObject item);
	void registerNew(List<SObject> items);
	void registerUpsert(SObject item);
	void registerUpsert(List<SObject> items);
}