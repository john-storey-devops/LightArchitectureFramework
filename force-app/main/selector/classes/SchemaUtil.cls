public class SchemaUtil {

    private static Set<String> problematicFieldNames = new Set<String>();

    public static String GetSObjectFieldsAsString(SObjectType sobjType)
    {
        return String.join(new List<String>(GetSObjectFieldsAsSet(sobjType)), ', ');
    }

    public static Set<String> GetSObjectFieldsAsSet(SObjectType sobjType)
    {
        Set<String> fieldSet = new Set<String>();

        for (SObjectField fld : sobjType.getDescribe().fields.getMap().values())
        {
            if (!fld.getDescribe().isAccessible()) continue;

            fieldSet.add(fld.getDescribe().getName().toLowerCase());
        }

        return fieldSet;
    }

    public static String JoinSObjectFieldsForQuery(Set<SObjectField> sobjectfieldList)
    {
        List<String> fieldNameList = new List<String>();
        for (SObjectField fld : sobjectfieldList)
        {
            fieldNameList.add(fld.getDescribe().getName());
        }

        return
            String.join(fieldNameList, '.')
            .replace('__c.', '__r.')
            .replaceAll('([Ii]{1}[Dd]{1}[.]{1})', '.');
    }

    public static Set<String> ProblematicFieldsToExcludeFromQueries_AllLowerCase()
    {
        // Occasionally for unknown reason, certain SObjectFields cause problems in SOQL.
        // At one time "LastModifiedDate" was causing problems.  Use this method to specify
        // fields that should be universally excluded from SOQL queries.

        // problematicFieldNames.add('lastmodifieddate');

        return problematicFieldNames;
    }
}
