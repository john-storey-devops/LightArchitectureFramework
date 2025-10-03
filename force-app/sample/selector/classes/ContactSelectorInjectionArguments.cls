public inherited sharing class ContactSelectorInjectionArguments
    implements ISelectorArgumentable
{
    public String nameLikeValue;

    public Object get(String key)
    {
        if (!'search_text'.equalsIgnoreCase(key))
        {
            throw new SObjectSelectorException('Unknown key value');
        }

        return nameLikeValue;
    }

    public static ContactSelectorInjectionArguments newInstance(String nameLikeValue)
    {
        ContactSelectorInjectionArguments args = new ContactSelectorInjectionArguments();
        args.nameLikeValue = nameLikeValue;
        return args;
    }
}