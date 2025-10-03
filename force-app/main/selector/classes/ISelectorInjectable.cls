public interface ISelectorInjectable
{
    List<SObject> selectQuery();
    ISelectorInjectable setArguments(ISelectorArgumentable arguments);
    void setFieldList(String soqlStyleFields);
    void setSObjectType(SObjectType soType);
}