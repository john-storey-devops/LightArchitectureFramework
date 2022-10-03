public virtual inherited sharing class UnitOfWork
	implements IUnitOfWork
{
	private SObjectType instanceSObjectType;

	private UnitOfWorkArtifacts.DmlOperation operationMode;

	@TestVisible
	private IDml dmlImplementation;

	private List<SObject> itemList = new List<SObject>();

	public virtual List<Object> commitWork()
	{
		switch on operationMode
		{
			when DELETE_OPERATION
			{
				return dmlImplementation.doDelete(itemList);
			}
			when INSERT_OPERATION
			{
				return dmlImplementation.doInsert(itemList);
			}
			when UPDATE_OPERATION
			{
				return dmlImplementation.doUpdate(itemList);
			}
			when UPSERT_OPERATION
			{
				return dmlImplementation.doUpsert(itemList);
			}
			when else
			{
				return new List<Object>();
			}
		}
	}

	public virtual UnitOfWorkArtifacts.DmlOperation getDmlOperation()
	{
		return operationMode;
	}

	public virtual SObjectType getSObjectType()
	{
		return instanceSObjectType;
	}

	public virtual void register(SObject item)
	{
		register(new List<SObject> {item});
	}

	public virtual void register(List<SObject> items)
	{
		addItemsToList(itemList, items);
	}

	private void addItemsToList(List<SObject> instanceList, List<SObject> newItems)
	{
		if (newItems == null || newItems.isEmpty())
		{
			return;
		}

		compareCorrectSObjectType(newItems.get(0).getSObjectType());
		instanceList.addAll(newItems);
	}

	private void compareCorrectSObjectType(SObjectType itemType)
	{
		if (instanceSObjectType != itemType)
		{
			throw new UnitOfWorkException('Can only add item(s) of SObjectType ' + instanceSObjectType.getDescribe().getName());
		}
	}

	private UnitOfWork(SObjectType sobjType, UnitOfWorkArtifacts.DmlOperation intendedOperation, IDml dmlImpl)
	{
		instanceSObjectType = sobjType;
		operationMode = intendedOperation;
		dmlImplementation = dmlImpl;
	}

	public static IUnitOfWork newInstance(SObjectType sobjType, UnitOfWorkArtifacts.DmlOperation intendedOperation)
	{
		return newInstance(sobjType, intendedOperation, new StandardDml());
	}

	public static IUnitOfWork newInstance(SObjectType sobjType, UnitOfWorkArtifacts.DmlOperation intendedOperation, IDml dmlImpl)
	{
		System.debug(sobjType.getDescribe().getName());
		return new UnitOfWork(sobjType, intendedOperation, dmlImpl);
	}
}