public with sharing class GoogleGeoCodingService
{
	// https://maps.googleapis.com/maps/api/geocode/json?
	// address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&
	// key=YOUR_API_KEY

	// ========== Implementation Methods ==================
	public static Location getLatitudeLongitudeForAddress(GoogleAddress addr)
	{
		Location loc = null;

		if (GoogleGeoCodingGetCallout.getIsEnabledInThisOrg() || isTest)
		{

			if (addr == null) {
				throw
					new GoogleGeoCodingExceptions.ParameterException(
						GoogleGeoCodingExceptions.ADDRESS_PARAMETER_NULL_MESSAGE);
			}

			if ( ! addr.isValidAddress() )
			{
				throw
					new GoogleGeoCodingExceptions.ParameterException(
						GoogleGeoCodingExceptions.INSUFFICIENT_DATA_MESSAGE);
			}

			String addressString = '';
			if (!String.isEmpty(addr.getStreet())) addressString += addr.getStreet() + ' ';
			if (!String.isEmpty(addr.getCity())) addressString += addr.getCity() + ' ';
			if (!String.isEmpty(addr.getState())) addressString += addr.getState() + ' ';
			if (!String.isEmpty(addr.getPostalCode())) addressString += addr.getPostalCode() + ' ';
			if (!String.isEmpty(addr.getCountry())) addressString += addr.getCountry();
			addressString = addressString.trim();
			addressString = addressString.replace('  ', ' ');

			Map<String, String> paramMap = new Map<String, String>();
			paramMap.put('address', EncodingUtil.urlEncode(addressString, 'UTF-8'));
			system.debug('getLatitudeLongitudeForAddress area mark 3 - paramMap : '+ paramMap );
			GoogleGeoCodingGetCallout callout = GoogleGeoCodingGetCallout.newInstance(paramMap);

			try {
				callout.execute();
			}
			catch (Exception e) {
				throw new GoogleGeoCodingExceptions.CalloutExecutionException(e.getMessage(), e);
			}

			GoogleGeoCodingResponse calloutResponse = (GoogleGeoCodingResponse) callout.getResponse();

			if ('OK'.equalsIgnoreCase(calloutResponse.status)) {
				loc =
					Location.newInstance(
						Decimal.valueOf(calloutResponse.results.get(0).geometry.location.lat),
						Decimal.valueOf(calloutResponse.results.get(0).geometry.location.lng)
					);
			}
			else {
				throw new GoogleGeoCodingExceptions.ParameterException(calloutResponse.error_message);
			}
		}
		else {
			throw
				new GoogleGeoCodingExceptions.ParameterException(
					GoogleGeoCodingExceptions.DISABLED_SERVICE_MESSAGE);
		}

		return loc;
	}

    /**************************************************************
     *  Testing Context
    **************************************************************/

    private static Boolean isTest = false;

    @TestVisible
    private static void setIsTest()
    {
        isTest = true;
    }
}