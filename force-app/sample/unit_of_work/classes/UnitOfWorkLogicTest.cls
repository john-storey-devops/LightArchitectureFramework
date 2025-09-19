@IsTest
private class UnitOfWorkLogicTest
{
	@IsTest
	private static void testDoSomeBasicUnitOfWorkStuff()
	{
		IUnitOfWork uowInsert = UnitOfWork.newInstance(Contact.SObjectType, UnitOfWorkArtifacts.DmlOperation.INSERT_OPERATION, new InertDml());
		IUnitOfWork uowUpdate = UnitOfWork.newInstance(Contact.SObjectType, UnitOfWorkArtifacts.DmlOperation.UPDATE_OPERATION, new InertDml());
		IUnitOfWork uowDelete = UnitOfWork.newInstance(Contact.SObjectType, UnitOfWorkArtifacts.DmlOperation.DELETE_OPERATION, new InertDml());

		Application.Unit_Of_Work.setMock(uowInsert);
		Application.Unit_Of_Work.setMock(uowUpdate);
		Application.Unit_Of_Work.setMock(uowDelete);

		Contact ctc = new Contact();
		ctc.FirstName = 'Lyndsey';
		ctc.LastName = 'Ververs';

		MockContactSelector mock = new MockContactSelector();
		mock.contactList.add(ctc);

		Application.Selector.setMock(Contact.SObjectType, mock);

		UnitOfWorkLogic.doSomeBasicUnitOfWorkStuff(ctc);

		IDml dmlImpl = ((UnitOfWork) uowInsert).dmlImplementation;
		InertDml inert = (InertDml) dmlImpl;
        Assert.isTrue(!inert.operationsSObjectList.isEmpty());
		Assert.areEqual(ctc.FirstName, ((Contact) inert.operationsSObjectList.get(0)).FirstName);

		dmlImpl = ((UnitOfWork) uowUpdate).dmlImplementation;
		inert = (InertDml) dmlImpl;
        Assert.isTrue(!inert.operationsSObjectList.isEmpty());
		Assert.areEqual(ctc.FirstName, ((Contact) inert.operationsSObjectList.get(0)).FirstName);

		dmlImpl = ((UnitOfWork) uowDelete).dmlImplementation;
		inert = (InertDml) dmlImpl;
        Assert.isTrue(!inert.operationsSObjectList.isEmpty());
		Assert.areEqual(ctc.FirstName, ((Contact) inert.operationsSObjectList.get(0)).FirstName);
	}

	@IsTest
	private static void testDoSomeAdvancedUnitOfWorkStuff()
	{
		UnitOfWorkLogic.doSomeAdvancedUnitOfWorkStuff();
	}

	public class MockContactSelector
		implements IContactSelector
	{
		public List<Contact> contactList = new List<Contact>();

		public List<Contact> selectById(Set<Id> idSet) {
			return contactList;
		}

		public SObjectType sobjectType() {
			return Contact.SObjectType;
		}

        public IContactSelector addAdditionalSObjectFields(List<SObjectField> additionalFields) {
            return this;
        }
    }
}