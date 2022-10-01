public inherited sharing class InertDml
	implements IDml
{

	public List<Database.DeleteResult> doDelete(List<SObject> deleteList) {
		return new List<Database.DeleteResult>();
	}

	public List<Database.SaveResult> doInsert(List<SObject> insertList) {
		return new List<Database.SaveResult>();
	}

	public List<Database.SaveResult> doUpdate(List<SObject> updateList) {
		return new List<Database.SaveResult>();
	}

	public List<Database.UpsertResult> doUpsert(List<SObject> upsertList) {
		return new List<Database.UpsertResult>();
	}
}