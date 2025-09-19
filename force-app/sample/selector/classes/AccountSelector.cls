public virtual inherited sharing class AccountSelector
    extends SObjectSelector
    implements IAccountSelector
{
    public static IAccountSelector newInstance() {
        return (IAccountSelector) Application.Selector.newInstance(Account.SObjectType);
    }

    public override Schema.SObjectType sobjectType() {
        return Account.SObjectType;
    }

    protected virtual List<SObjectField> getStandardFields()
    {
        return new List<SObjectField>{
            Account.Id,
            Account.Name,
            Account.Description
        };
    }

    public IAccountSelector addAdditionalSObjectFields(List<SObjectField> additionalFields) {
        additionalSObjectFieldList.addAll(additionalFields);
        return this;
    }

    private Set<String> getLookupFieldSet()
    {
        return new Set<String>
        {
            SchemaUtil.JoinSObjectFieldsForQuery(
                new Set<Schema.SObjectField>
                {
                    Account.OwnerId
                }
            )
        };
    }

    public List<Account> selectById(Set<Id> idSet) {
        return selectSObjectById(idSet);
    }

    public List<Account> selectByNameContains(String search_text) {

        /*
         *    Using text input, like this argument, without proper precautions
         *    is highly discouraged, but for the purposes of illustration this
         *    code does not perform any security screening.
         */

        if (String.isNotBlank(search_text)) return new List<Account>();

        /*
         *    More robust frameworks have programmatic means for generating
         *    SOQL statements that consider various access settings.
         */

        String soql =
            'SELECT '
            + getFieldsToQuery() + ' ' +
            + 'FROM ' + sobjectType() + ' '
            + 'WHERE Name LIKE \':search_text%\'' + ' '
            + 'WITH USER_MODE';

        return Database.query(soql);
    }
}
