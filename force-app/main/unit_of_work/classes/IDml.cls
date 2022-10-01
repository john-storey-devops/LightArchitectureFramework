public interface IDml
{
	List<Database.DeleteResult> doDelete(List<SObject> deleteList);
	List<Database.SaveResult> doInsert(List<SObject> insertList);
	List<Database.SaveResult> doUpdate(List<SObject> updateList);
	List<Database.UpsertResult> doUpsert(List<SObject> upsertList);
}