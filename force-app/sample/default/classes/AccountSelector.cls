public inherited sharing class AccountSelector
    extends SObjectSelector
    implements IAccountSelector {

        public static IAccountSelector newInstance() {
            return (IAccountSelector) Application.selector.newInstance(Account.SObjectType);
        }

        public override Schema.sObjectType sObjectType() {
            return Account.SObjectType;
        }

        private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
            List<Schema.SObjectField> fieldList = Account.SObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).fields.getMap().values();
            return fieldList;
        }
    
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
