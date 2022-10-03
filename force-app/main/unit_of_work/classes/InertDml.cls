public inherited sharing class InertDml
	implements IDml
{
	@TestVisible
	private List<SObject> operationsSObjectList = new List<SObject>();
	public List<Database.DeleteResult> doDelete(List<SObject> deleteList)
	{
		operationsSObjectList.clear();
		if (deleteList != null) operationsSObjectList.addAll(deleteList);
		return new List<Database.DeleteResult>();
	}

	public List<Database.SaveResult> doInsert(List<SObject> insertList)
	{
		operationsSObjectList.clear();
		if (insertList != null) operationsSObjectList.addAll(insertList);
		return new List<Database.SaveResult>();
	}

	public List<Database.SaveResult> doUpdate(List<SObject> updateList)
	{
		operationsSObjectList.clear();
		if (updateList != null) operationsSObjectList.addAll(updateList);
		return new List<Database.SaveResult>();
	}

	public List<Database.UpsertResult> doUpsert(List<SObject> upsertList)
	{
		operationsSObjectList.clear();
		if (upsertList != null) operationsSObjectList.addAll(upsertList);
		return new List<Database.UpsertResult>();
	}
}