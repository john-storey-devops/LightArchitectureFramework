public virtual class NamedCredentialCalloutAuth
    implements ICalloutAuthorizationable
{
    private String identifier = '';

    public String getIdentifier()
    {
        return identifier;
    }

    public NamedCredentialCalloutAuth setIdentifier(String value)
    {
        this.identifier = value;
        return this;
    }

    public void setAuthorization(HttpRequest request)
    {
        if (request != null)
        {
            // replace the existing https://www.acme.com -- protocol and host with   callout:namedCredentialIdentifier/pathAndQuery

            Url u = new Url(request.getEndpoint());
            String path = u.getPath();
            String query = u.getQuery();

            String workingUrl = 'callout:' + getIdentifier();

            if (String.isNotBlank(path))
            {
                workingUrl += path.startsWith('/') ? '' : '/';
                workingUrl += path;
            }

            if (String.isNotBlank(query))
            {
                workingUrl += query.startsWith('?') ? '' : '?';
                workingUrl += query;
            }

            System.debug(System.LoggingLevel.INFO, workingUrl );

            request.setEndpoint( workingUrl );
        }
        else
        {
            system.debug( System.LoggingLevel.WARN, 'An HttpRequest is required.');
        }
    }
}