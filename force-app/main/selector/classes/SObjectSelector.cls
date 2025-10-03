public abstract class SObjectSelector
    implements ISObjectSelector
{
    public abstract SObjectType sobjectType();

    abstract List<Schema.SObjectField> getStandardFields();

    protected List<Schema.SObjectField> additionalSObjectFieldList = new List<SObjectField>();
    protected List<Schema.SObjectField> getAdditionalSObjectFieldList()
    {
        return additionalSObjectFieldList;
    }

    abstract Set<String> getLookupFieldSet();

    protected String getFieldsToQuery() {

        List<String> fields = new List<String>();

        List<Schema.SObjectField> allFieldToQuery = getStandardFields();
        allFieldToQuery.addAll(additionalSObjectFieldList);
    
        for (SObjectField fld : allFieldToQuery)
        {
            if (!fld.getDescribe().isAccessible()) continue;

            String fieldName = fld.getDescribe().getName().toLowerCase();

            if (!SchemaUtil.ProblematicFieldsToExcludeFromQueries_AllLowerCase().contains(fieldName.toLowerCase())) {
                fields.add(fieldName);
            }
        }

        // Without extensive code which this modest framework wishes to avoid,
        // validating the existence and accessibility of lookup fields is impractical.
        fields.addAll(getLookupFieldSet());

        return String.join(fields, ', ');
    }

    protected List<SObject> selectSObjectById(Set<Id> idSet) {
    
        if (idSet == null || idSet.isEmpty()) return new List<Account>();

        String soql =
            'SELECT '
            + getFieldsToQuery() + ' ' +
            + 'FROM ' + sobjectType() + ' '
            + 'WHERE id IN :idSet' + ' '
            + 'WITH USER_MODE';

        return (List<SObject>) Database.query(soql);
    }

    public virtual List<SObject> selectWithInjectable(Type injectableClassType, ISelectorArgumentable arguments)
    {
        if ( injectableClassType == null )
        {
            throw new SObjectSelectorException('methodClazz cannot be null');
        }

        try
        {
            ISelectorInjectable injectableClass = (ISelectorInjectable)injectableClassType.newInstance();
            injectableClass.setSObjectType(sobjectType());
            injectableClass.setFieldList(getFieldsToQuery());

            if (arguments != null)
            {
                injectableClass.setArguments(arguments);
            }

            return injectableClass.selectQuery();
        }
        catch (System.TypeException te)
        {
            throw new SObjectSelectorException('Parameter injectableClassType of type \'' + injectableClassType.getName() + '\' does not implement the interface \'' + ISelectorInjectable.class.getName() + '\'');
        }
        catch (System.Exception e)
        {
            throw new SObjectSelectorException(e);
        }
    }
}
