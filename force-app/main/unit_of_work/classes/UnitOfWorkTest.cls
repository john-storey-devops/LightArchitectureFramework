@IsTest
private class UnitOfWorkTest
{
	@IsTest
	private static void typicalInstantiation()
    {
        IUnitOfWork uow = UnitOfWork.newInstance(Opportunity.SObjectType, UnitOfWorkArtifacts.DmlOperation.INSERT_OPERATION);
        Assert.isInstanceOfType(uow, UnitOfWork.class);
		Assert.areEqual(Opportunity.SObjectType, uow.getSObjectType());
		Assert.areEqual(UnitOfWorkArtifacts.DmlOperation.INSERT_OPERATION, uow.getDmlOperation());
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
			Assert.fail('InertDML should have prevented execution of the Update operation.');
		}
	}

	@IsTest
	private static void differentSObjectTypeCausesException()
	{
		IUnitOfWork uow = UnitOfWork.newInstance(Opportunity.SObjectType, UnitOfWorkArtifacts.DmlOperation.INSERT_OPERATION);

		try
		{
			uow.register(new Account());
			Assert.fail('Registering a SObject different than the configured SObjectType should generate an Exception.');
		}
		catch(Exception exc)
		{
			Assert.isTrue(
				exc.getMessage().startsWith('Can only add item(s) of SObjectType'),
				'Expected Exception not generated.  Actual: ' + exc.getMessage()
			);
		}
	}
}