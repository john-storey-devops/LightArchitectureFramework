/**
 *  BaseCallout
 *
 *  The base class used for all callouts
 */
public abstract class BaseCallout
{
    public enum CALLOUT_METHODS
    {
        POST, GET
    }

    private map<String, String> headerMap = new map<String, String>();

    protected ICalloutAuthorizationable auth = null;

    protected boolean isDebugOn = false;

    protected abstract String getPath();

    protected abstract map<string, String> getParamMap();

    protected abstract CALLOUT_METHODS getMethod();

    protected abstract String getPostRequestBody();

    public abstract BaseCallout execute();

    protected abstract String getHost();

    protected virtual String getProtocol()
    {
        return 'https';
    }

    public virtual BaseCallout setAuthorization( ICalloutAuthorizationable auth )
    {
        this.auth = auth;
        return this;
    }

    public map<String, String> getHeaderMap()
    {
        return this.headerMap;
    }

    public String getProtocolAndHost()
    {
        return getProtocol() + '://' + getHost();
    }

    private HttpRequest getRequest()
    {
        if ( isDebugOn )
        {
            System.debug( 'url == ' + getProtocolAndHost() + getPath() );
            System.debug( 'paramMap == ' + getParamMap() );
            System.debug( 'headerMap == ' + getHeaderMap() );
            System.debug( 'postRequestBody == ' + getPostRequestBody() );
        }

        string HTTPMethod = getMethod() == null ? CALLOUT_METHODS.GET.name() : getMethod().name();

        return
            HttpRequestFactory.buildHttpRequest(
                HTTPMethod,
                getProtocol(),
                getHost(),
                getPath(),
                getParamMap(),
                getHeaderMap(),
                getPostRequestBody(),
                auth
            );
    }

    protected virtual HttpResponse executeCallout()
    {
        if (mockHttpResponse == null)
            return new Http().send(getRequest());
        else
            return mockHttpResponse;
    }

    public BaseCallout debug()
    {
        this.isDebugOn = true;
        return this;
    }

    public abstract CalloutResponse getResponse();

    public interface CalloutResponse
    {
        integer getTotalNumberOfRecordsFound();
    }

    /**************************************************************
     *  Testing Context
    **************************************************************/

    private static HttpResponse mockHttpResponse = null;

    @TestVisible
    private static void setMockHttpResponse(HttpResponse mock_response)
    {
        mockHttpResponse = mock_response;
    }
}