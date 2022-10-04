@IsTest
private class UnitOfWorkTest
{
	@IsTest
	private static void typicalInstantiation()
    {
        IUnitOfWork uow = UnitOfWork.newInstance(Opportunity.SObjectType, UnitOfWorkArtifacts.DmlOperation.INSERT_OPERATION);
        System.assert(uow instanceof UnitOfWork);
		System.assertEquals(Opportunity.SObjectType, uow.getSObjectType());
		System.assertEquals(UnitOfWorkArtifacts.DmlOperation.INSERT_OPERATION, uow.getDmlOperation());
	}

	@IsTest
	private static void instanceWithInertDml()
	{
		Opportunity opp = new Opportunity(Id = TestUtils.mockId(Opportunity.SObjectType));
		IUnitOfWork uow = UnitOfWork.newInstance(Opportunity.SObjectType, UnitOfWorkArtifacts.DmlOperation.UPDATE_OPERATION, new InertDml());
		uow.register(opp);

		try
		{
			uow.commitWork();
		}
		catch (Exception exc)
		{
			System.assert(false, 'InertDML should have prevented execution of the Update operation.');
		}
	}

	@IsTest
	private static void differentSObjectTypeCausesException()
	{
		IUnitOfWork uow = UnitOfWork.newInstance(Opportunity.SObjectType, UnitOfWorkArtifacts.DmlOperation.INSERT_OPERATION);

		try
		{
			uow.register(new Account());
			System.assert(false, 'Registering a SObject different than the configured SObjectType should generate an Exception.');
		}
		catch(Exception exc)
		{
			System.assert(
				exc.getMessage().startsWith('Can only add item(s) of SObjectType'),
				'Expected Exception not generated.  Actual: ' + exc.getMessage()
			);
		}
	}
}