public class GoogleGeoCodingGetCallout
    extends BaseGETCallout
{
    // https://maps.googleapis.com/maps/api/geocode/json?
    // address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&
    // key=YOUR_API_KEY

    // ========== Construction ==================
    public static GoogleGeoCodingGetCallout newInstance()
    {
        return newInstance(null);
    }

    public static GoogleGeoCodingGetCallout newInstance(Map<String, String> paramMap)
    {
        GoogleGeoCodingGetCallout result = new GoogleGeoCodingGetCallout();
        if (paramMap != null) result.setParamMap(paramMap);
        return result;
    }

    private GoogleGeoCodingGetCallout()
    {
        // Hide from consumer.
    }

    // ========== Extension Methods ==================
    public override BaseCallout execute()
    {
        String responseBody = null;

        KeyValueParameterCalloutAuth auth = new KeyValueParameterCalloutAuth().setParamKey('key').setParamValue(GoogleGeoCodingGetCallout.getAccessKey());

        system.debug('auth == '+ auth);

        super.setAuthorization( auth );

        HttpResponse httpResp = super.executeCallout();
        responseBody = httpResp.getBody();

        if (isDebugOn)
        {
            System.debug('responseBody:\n' + responseBody);
        }

        calloutResponse = GoogleGeoCodingResponse.parse(responseBody);

        return this;
    }

    public override String getHost()
    {
        return 'maps.googleapis.com';
    }

    private Map<String, String> paramMap = new Map<String, String>();

    public override Map<String, String> getParamMap()
    {
        return this.paramMap;
    }

    public void setParamMap(Map<String, String> paramMap)
    {
        this.paramMap = paramMap;
    }

    public override String getPath()
    {
        return '/maps/api/geocode/json';
    }

    private GoogleGeoCodingResponse calloutResponse = null;
    public override BaseCallout.CalloutResponse getResponse()
    {
        return (BaseCallout.CalloutResponse) calloutResponse;
    }

    // ========== Feature Custom Settings ==================
    private static Boolean settingsRetrieved = false;
    private static String accessKey_m = '';
    private static Boolean isEnabled_m = false;
    private static Boolean isEnabledInSandbox_m = false;

    private static String getAccessKey()
    {
        getSettings();
        return accessKey_m;
    }

    public static Boolean getIsEnabled()
    {
        getSettings();
        return isEnabled_m;
    }

    public static Boolean getIsEnabledInSandbox()
    {
        getSettings();
        return isEnabledInSandbox_m;
    }

    public static Boolean getIsEnabledInThisOrg()
    {
        return
            GoogleGeoCodingGetCallout.getIsEnabled() &&
            (!Utils.org.isSandbox || GoogleGeoCodingGetCallout.getIsEnabledInSandbox());
    }

    private static void getSettings()
    {
        if ( ! settingsRetrieved)
        {

            Google_Maps_Integration__c settings = Google_Maps_Integration__c.getInstance();

            if (settings != null) {
                isEnabled_m = settings.Address_Geocoding_Enabled__c;
                isEnabledInSandbox_m = settings.Address_Geocoding_Enabled_In_Sandbox__c;
                accessKey_m = settings.Geocoding_Access_Key__c;
            }

            settingsRetrieved = true;
        }
    }
}