public inherited sharing class StandardDml
	implements IDml
{

	public List<Database.DeleteResult> doDelete(List<SObject> deleteList)
	{
		return Database.delete(deleteList);
	}

	public List<Database.SaveResult> doInsert(List<SObject> insertList)
	{
		return Database.insert(insertList);
	}

	public List<Database.SaveResult> doUpdate(List<SObject> updateList)
	{
		return Database.update(updateList);
	}

	public List<Database.UpsertResult> doUpsert(List<SObject> upsertList)
	{
		return Database.upsert(upsertList);
	}
}