public inherited sharing class AccountSelector
    implements IAccountSelector {

        /*
         *    The following methods are required by the framework.
         */

        public static IAccountSelector newInstance() {
            return (IAccountSelector) Application.selector.newInstance(Account.SObjectType);
        }
    
        public List<SObject> selectSObjectById(Set<Id> idSet) {
    
            if (idSet == null || idSet.isEmpty()) return new List<Account>();
    
            String soql =
                'select '
                + getFieldsToQuery() + ' ' +
                + 'from ' + sObjectType() + ' '
                + 'where id in :idSet';

            System.debug('js:\n' + soql);
    
            return (List<Account>) Database.query(soql);
        }

        public Schema.sObjectType sObjectType() {
            return Account.SObjectType;
        }
    
        /*
         *    The following methods are optional but will make further development
         *    much easier in within the selector's methods.
         */

        private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
            List<Schema.SObjectField> fieldList = Account.SObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).fields.getMap().values();
            return fieldList;
        }
    
        private String getFieldsToQuery() {
            List<String> fields = new List<String>();
    
            for (SObjectField fld : getAdditionalSObjectFieldList())
            {
                if (!fld.getDescribe().isAccessible()) continue;
    
                String fieldName = fld.getDescribe().getName().toLowerCase();
    
                /*
                 *    Some of the fields supplied by the Schema cause issues during SOQL operations.
                 *    Provide a means for excluding those problematic fields.
                 */
                    
                fields.add(fieldName);
            }
    
            return String.join(fields, ', ');
        }
    
        /*
         *    The following methods are specific to this implementation.
         */

        public List<Account> selectById(Set<Id> idSet) {
            return (List<Account>) selectSObjectById(idset);
        }
    
        public List<Account> selectByNameContains(String search_text) {
    
            if (String.isNotBlank(search_text)) return new List<Account>();
    
            String soql =
                'select '
                + getFieldsToQuery() + ' ' +
                + 'from ' + sObjectType() + ' '
                + 'where Name like \':search_text%\'';
    
            return (List<Account>) Database.query(soql);
        }
    }
