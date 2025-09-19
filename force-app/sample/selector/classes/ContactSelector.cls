public virtual inherited sharing class ContactSelector
	extends SObjectSelector
	implements IContactSelector
{
	public static IContactSelector newInstance()
	{
		return (IContactSelector) Application.Selector.newInstance(Contact.SObjectType);
	}

	public override Schema.SObjectType sobjectType()
	{
		return Contact.SObjectType;
	}

    private virtual List<Schema.SObjectField> getStandardFields() {
        return new List<Schema.SObjectField> {
            Contact.Id,
            Contact.Name
        };
    }

    public IContactSelector addAdditionalSObjectFields(List<SObjectField> additionalFields) {
        additionalSObjectFieldList.addAll(additionalFields);
        return this;
    }

	private Set<String> getLookupFieldSet()
	{
		return new Set<String>();
	}

	public List<Contact> selectById(Set<Id> idSet)
	{
		return selectSObjectById(idSet);
	}
}
