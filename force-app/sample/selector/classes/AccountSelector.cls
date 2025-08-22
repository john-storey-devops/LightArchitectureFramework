public virtual inherited sharing class AccountSelector
    extends SObjectSelector
    implements IAccountSelector
{
    public static IAccountSelector newInstance() {
        return (IAccountSelector) Application.Selector.newInstance(Account.SObjectType);
    }

    public override Schema.sObjectType sObjectType() {
        return Account.SObjectType;
    }

    private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
        List<Schema.SObjectField> fieldList = Account.SObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).fields.getMap().values();
        return fieldList;
    }

    private Set<String> getLookupFieldSet()
    {
        return new Set<String>
        {
            SchemaUtil.JoinSObjectFieldsForQuery(
                new Set<Schema.SObjectField>
                {
                    Account.OperatingHoursId,
                    OperatingHours.Description
                }
            )
        };
    }

    public List<Account> selectById(Set<Id> idSet) {
        return (List<Account>) selectSObjectById(idSet);
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
            + 'FROM ' + sObjectType() + ' '
            + 'WHERE Name LIKE \':search_text%\'' + ' '
            + 'WITH USER_MODE';

        return (List<Account>) Database.query(soql);
    }
}
