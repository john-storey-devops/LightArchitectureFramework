public inherited sharing class UnitOfWork
	implements IUnitOfWork
{
	private SObjectType instanceSObjectType;

	private DmlOperations.DMLOPERATION operationMode;

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

	public DmlOperations.DMLOPERATION getDmlOperation()
	{
		return operationMode;
	}

	public SObjectType getSObjectType()
	{
		return instanceSObjectType;
	}

	public void registerDelete(SObject item)
	{
		registerDelete(new List<SObject> {item});
	}

	public void registerDelete(List<SObject> items)
	{
		compareOperationMode(DmlOperations.DMLOPERATION.DELETE_OPERATION);
		addItemsToList(itemList, items);
	}

	public void registerDirty(SObject item)
	{
		registerDirty(new List<SObject> {item});
	}

	public void registerDirty(List<SObject> items)
	{
		compareOperationMode(DmlOperations.DMLOPERATION.UPDATE_OPERATION);
		addItemsToList(itemList, items);
	}

	public void registerNew(SObject item)
	{
		registerNew(new List<SObject> {item});
	}

	public void registerNew(List<SObject> items)
	{
		compareOperationMode(DmlOperations.DMLOPERATION.INSERT_OPERATION);
		addItemsToList(itemList, items);
	}

	public void registerUpsert(SObject item)
	{
		registerUpsert(new List<SObject> {item});
	}

	public void registerUpsert(List<SObject> items)
	{
		compareOperationMode(DmlOperations.DMLOPERATION.UPSERT_OPERATION);
		addItemsToList(itemList, items);
	}

	private void addItemsToList(List<SObject> instanceList, List<SObject> newItems)
	{
		compareCorrectSObjectType(newItems.getSObjectType());
		instanceList.addAll(newItems);
	}

	private void compareCorrectSObjectType(SObjectType itemType)
	{
		if (instanceSObjectType != itemType)
		{
			throw new UnitOfWorkException('Can only add item(s) of SObjectType ' + instanceSObjectType.getDescribe().getName());
		}
	}

	private void compareOperationMode(DmlOperations.DMLOPERATION mode)
	{
		if (!operationMode.equals(mode))
		{
			throw new UnitOfWorkException('Unit of Work configured for ' + operationMode.name() + ' operations.');
		}
	}

	private UnitOfWork(SObjectType sobjType, DmlOperations.DMLOPERATION intendedOperation, IDml dmlImpl)
	{
		instanceSObjectType = sobjType;
		operationMode = intendedOperation;
		dmlImplementation = dmlImpl;
	}

	public static IUnitOfWork newInstance(SObjectType sobjType, DmlOperations.DMLOPERATION intendedOperation)
	{
		return newInstance(sobjType, intendedOperation, new StandardDml());
	}

	public static IUnitOfWork newInstance(SObjectType sobjType, DmlOperations.DMLOPERATION intendedOperation, IDml dmlImpl)
	{
		return new UnitOfWork(sobjType, intendedOperation, dmlImpl);
	}
}