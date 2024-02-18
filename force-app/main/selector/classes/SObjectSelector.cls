public abstract class SObjectSelector
    implements ISObjectSelector
{
    public abstract SObjectType sobjectType();

    abstract List<Schema.SObjectField> getAdditionalSObjectFieldList();

    abstract Set<String> getLookupFieldSet();

    protected String getFieldsToQuery() {

        List<String> fields = new List<String>();
    
        for (SObjectField fld : getAdditionalSObjectFieldList())
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
            + 'FROM ' + sObjectType() + ' '
            + 'WHERE id IN :idSet' + ' '
            + 'WITH USER_MODE';

        return (List<SObject>) Database.query(soql);
    }  
}
