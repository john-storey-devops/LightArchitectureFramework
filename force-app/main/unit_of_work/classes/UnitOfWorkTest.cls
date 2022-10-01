@IsTest
private class UnitOfWorkTest
{
	@IsTest
	private static void typicalInstantiation()
    {
        IUnitOfWork uow = UnitOfWork.newInstance(Opportunity.SObjectType, DmlOperations.DMLOPERATION.INSERT_OPERATION);
        System.assert(uow instanceof UnitOfWork);
		System.assertEquals(Opportunity.SObjectType, uow.getSObjectType());
		System.assertEquals(DmlOperations.DMLOPERATION.INSERT_OPERATION, uow.getDmlOperation());
	}

	@IsTest
	private static void instanceWithInertDml()
	{
		Opportunity opp = new Opportunity(Id = TestUtils.mockId(Opportunity.SObjectType));
		IUnitOfWork uow = UnitOfWork.newInstance(Opportunity.SObjectType, DmlOperations.DMLOPERATION.UPDATE_OPERATION, new InertDml());
		uow.registerDirty(opp);
		uow.commitWork();
	}
}