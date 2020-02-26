public inherited sharing class AccountSelector
    implements IAccountSelector {

        public static IAccountSelector newInstance() {
            return (IAccountSelector) Application.selector.newSelector(Account.SObjectType);
        }
    
        public Schema.sObjectType sObjectType() {
            return Account.SObjectType;
        }
    
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
    
        public List<SObject> selectSObjectById(Set<Id> idSet) {
    
            if (idSet == null || idSet.isEmpty()) return new List<Account>();
    
            String soql =
                'select '
                + getFieldsToQuery()
                + 'from ' + sObjectType() + ' '
                + 'where id in :idSet';
    
            return (List<Account>) Database.query(soql);
        }

        public List<Account> selectById(Set<Id> idSet) {
            return (List<Account>) selectSObjectById(idset);
        }
    
        public List<Account> selectNameContains(String search_text) {
    
            if (String.isNotBlank(search_text)) return new List<Account>();
    
            String soql =
                'select '
                + getFieldsToQuery()
                + 'from ' + sObjectType() + ' '
                + 'where Name like \':search_text%\'';
    
            return (List<Account>) Database.query(soql);
        }
    }
