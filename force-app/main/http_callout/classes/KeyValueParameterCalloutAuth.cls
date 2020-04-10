public virtual class KeyValueParameterCalloutAuth
    implements ICalloutAuthorizationable
{
    private String paramKey = '';

    public String getParamKey()
    {
        return paramKey;
    }

    public KeyValueParameterCalloutAuth setParamKey(String value)
    {
        this.paramKey = value;
        return this;
    }

    private String paramValue = '';

    public String getParamValue()
    {
        return paramValue;
    }

    public KeyValueParameterCalloutAuth setParamValue(String value)
    {
        this.paramValue = value;
        return this;
    }

    public void setAuthorization(HttpRequest request)
    {
        if (request != null)
        {
            String connector = '?';

            if (request.getEndpoint().contains(connector))
                connector = '&';

            request.setEndpoint(
                request.getEndpoint() +
                connector +
                getParamKey() + '=' + getParamValue()
            );
        }
        else
        {
            system.debug( System.LoggingLevel.WARN, 'An HttpRequest is required.');
        }
    }
}