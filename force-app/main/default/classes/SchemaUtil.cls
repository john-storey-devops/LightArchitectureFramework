public class SchemaUtil {

    public static Set<String> ProblematicFieldsToExcludeFromQueries_AllLowerCase() {

        return
            new Set<String> {
                // Populate fields in lower case for text comparison where implemented.
                'lastmodifieddate'
            };
    }
}
