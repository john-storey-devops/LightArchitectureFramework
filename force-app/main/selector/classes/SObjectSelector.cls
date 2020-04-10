public abstract class SObjectSelector
    implements ISObjectSelector {

    public abstract SObjectType sobjectType();

    abstract List<Schema.SObjectField> getAdditionalSObjectFieldList();

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

        return String.join(fields, ', ');
    }

    protected List<SObject> selectSObjectById(Set<Id> idSet) {
    
        if (idSet == null || idSet.isEmpty()) return new List<Account>();

        String soql =
            'select '
            + getFieldsToQuery() + ' ' +
            + 'from ' + sObjectType() + ' '
            + 'where id in :idSet';

        System.debug('js:\n' + soql);

        return (List<Account>) Database.query(soql);
    }  
}
