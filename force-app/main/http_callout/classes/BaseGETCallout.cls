/**
 *  BaseGETCallout
 */
public abstract class BaseGETCallout
    extends BaseCallout
{
    protected override CALLOUT_METHODS getMethod()
    {
        return CALLOUT_METHODS.GET;
    }

    protected override String getPostRequestBody()
    {
        return null;
    }
}