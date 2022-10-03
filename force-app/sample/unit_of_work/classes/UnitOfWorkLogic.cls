public inherited sharing class UnitOfWorkLogic
{
	public static void doSomeBasicUnitOfWorkStuff(Contact ctc)
	{
		System.assert(ctc != null, 'Contact cannot be null');

		System.Savepoint sp = Database.setSavepoint();

		try
		{
			IUnitOfWork uow = Application.Unit_Of_Work.newInstance(Contact.SObjectType, UnitOfWorkArtifacts.DmlOperation.INSERT_OPERATION);
			uow.register(ctc);
			uow.commitWork();

			IContactSelector contactSelector = (IContactSelector) Application.Selector.newInstance(Contact.SObjectType);

			List<Contact> contactList = contactSelector.selectById(new Set<Id> {ctc.Id});
			System.assert(!contactList.isEmpty(), 'Contact was not created.');

			try
			{
				Account acct = new Account();
				uow.register(acct);
			}
			catch(Exception exc)
			{
				// As expected.
				// The Unit of Work is configured for Opportunities,
				// so the addition of an Account generated an Exception.
			}

			uow = Application.Unit_Of_Work.newInstance(Contact.SObjectType, UnitOfWorkArtifacts.DmlOperation.UPDATE_OPERATION);
			ctc.Description = 'hello';
			uow.register(ctc);
			uow.commitWork();

			contactList = contactSelector.selectById(new Set<Id> {ctc.Id});
			System.assertEquals('hello', contactList.get(0).Description);

			uow = Application.Unit_Of_Work.newInstance(Contact.SObjectType, UnitOfWorkArtifacts.DmlOperation.DELETE_OPERATION);
			uow.register(ctc);
			uow.commitWork();
		}
		finally
		{
			// Explicitly reset the org to the beginning state.
			Database.rollback(sp);
		}
	}

	public static void doSomeAdvancedUnitOfWorkStuff()
	{
		/*
		 *		More sophisticated frameworks can do all of the Lookup seeding automatically,
		 *		however the following is one, of many, possible means for doing so with this framework.
		 */

		System.Savepoint sp = Database.setSavepoint();

		// First we're creating a loose relationship structure which represents data
		// that we may have gotten from a data import or information enter through some UI.
		List<Account> accountList = new List<Account>();

		// Remember.  The Account Domain places a requirement on the Description field.
		accountList.add(new Account(Name='Acme Supplies', Description='Our products ALWAYS work'));
		accountList.add(new Account(Name='Birdseed Farm', Description='Yum!  Yum!'));

		Map<Integer, List<Contact>> contactMap = new Map<Integer, List<Contact>>();
		contactMap.put(0, new List<Contact>());
		contactMap.get(0).add(new Contact(FirstName='Wile', LastName='Coyote'));
		contactMap.get(0).add(new Contact(FirstName='Wile', LastName='Coyote Jr.'));
		contactMap.put(1, new List<Contact>());
		contactMap.get(1).add(new Contact(FirstName='Road', LastName='Runner'));
		contactMap.get(1).add(new Contact(FirstName='Tweety', LastName='Bird'));

		// Inserting the Accounts.
		// Remember that Salesforce will covertly populate the Id for the SObjects inserted.
		IUnitOfWork accountUow = Application.Unit_Of_Work.newInstance(Account.SObjectType, UnitOfWorkArtifacts.DmlOperation.INSERT_OPERATION);
		accountUow.register(accountList);
		accountUow.commitWork();

		// After populating the Contacts' Account field, insert them
		IUnitOfWork contactUow = Application.Unit_Of_Work.newInstance(Contact.SObjectType, UnitOfWorkArtifacts.DmlOperation.INSERT_OPERATION);
		relateContactsAndPopulateUow(accountList, contactMap, contactUow);
		contactUow.commitWork();

		// In the debug log, you may visualize the structure from the Salesforce data
		System.debug(
			JSON.serializePretty(
				[
					SELECT
						Id, Name, Description,
						(SELECT Id, Name FROM Contacts)
					FROM Account
					WHERE Id IN :extractIdSet(accountList)
				]));

		// Restore the org to its data before this method.
		Database.rollback(sp);
	}

	private static Set<Id> extractIdSet(List<SObject> sobjList)
	{
		Set<Id> idSet = new Set<Id>();
		for (SObject sobj : sobjList)
		{
			idSet.add(sobj.Id);
		}
		return idSet;
	}

	private static void relateContactsAndPopulateUow(List<Account> accounts, Map<Integer, List<Contact>> contacts, IUnitOfWork contactUow)
	{
		Integer i = 0;
		for (Account acct : accounts)
		{
			for (Contact ctc : contacts.get(i++))
			{
				ctc.AccountId = acct.Id;
				contactUow.register(ctc);
			}
		}
	}
}