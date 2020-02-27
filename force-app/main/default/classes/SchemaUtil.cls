public class SchemaUtil {

    private static Set<String> problematicFieldNames = null;

    public static Set<String> ProblematicFieldsToExcludeFromQueries_AllLowerCase() {

        if (problematicFieldNames == null) {
            problematicFieldNames =
                new Set<String> {
                    // Populate fields in lower case for text comparison where implemented.
                    'lastmodifieddate'
                };
        }

        return problematicFieldNames;
    }
}
