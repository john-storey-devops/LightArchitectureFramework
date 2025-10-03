public inherited sharing class ContactSelectorInjection
    implements ISelectorInjectable
{
    private String search_text;

    public List<SObject> selectQuery() {

        String soql =
                'SELECT '
                + fields + ' ' +
                + 'FROM ' + soType.getDescribe().getName() + ' '
                + 'WHERE ' + Contact.LastName.getDescribe().getName() + ' LIKE :search_text '
                + 'WITH USER_MODE';

        return Database.query(soql);
    }

    public ContactSelectorInjection setArguments(ISelectorArgumentable arguments)
    {
        search_text = (String) arguments.get('search_text');
        return this;
    }

    private String fields;
    public void setFieldList(String soqlStyleFields)
    {
        fields = soqlStyleFields;
    }

    private SObjectType soType;
    public void setSObjectType(SObjectType soType)
    {
        this.soType = soType;
    }

    public static ContactSelectorInjection newInstance()
    {
        return new ContactSelectorInjection();
    }
}