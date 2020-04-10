public class GoogleGeoCodingExceptions
{
    public static final string ADDRESS_PARAMETER_NULL_MESSAGE = 'Address parameter may not be null.';
    public static final string DISABLED_SERVICE_MESSAGE = 'The service is disabled via custom settings.';
    public static final string INSUFFICIENT_DATA_MESSAGE = 'Insufficient data.  Street and State and Country and (City or Postal Code).';

    private GoogleGeoCodingExceptions()
	{
		// Hide from consumer.
	}

    public virtual class ServiceException
        extends Exception
    {
		// No code.
    }

	public class CalloutExecutionException
        extends GoogleGeoCodingExceptions.ServiceException
    {
		// No code.
    }

    public class ParameterException
        extends GoogleGeoCodingExceptions.ServiceException
    {
        // No code.
    }
}