@isTest
private class GoogleGeoCodingServiceTest
{
	@isTest
	private static void normalProcess()
	{
		HttpResponse mock_response = new HttpResponse();
		mock_response.setBody(String.join(getResponseJson(), ''));

		GoogleGeoCodingGetCallout.setMockHttpResponse(mock_response);
		GoogleGeoCodingService.setIsTest();

		Test.startTest();
		Location loc = GoogleGeoCodingService.getLatitudeLongitudeForAddress(getAddress());
		Test.stopTest();

		Assert.isNotNull(loc);
		Assert.areEqual(37.4224764, loc.getLatitude());
		Assert.areEqual(-122.0842499, loc.getLongitude());
	}

	@isTest
	private static void missingStreetInAddress()
	{
		HttpResponse mock_response = new HttpResponse();
		mock_response.setBody(String.join(getResponseJson(), ''));

		GoogleGeoCodingGetCallout.setMockHttpResponse(mock_response);
		GoogleGeoCodingService.setIsTest();

		GoogleAddress data = getAddress();
		data.setStreet(null);

		try
		{
			GoogleGeoCodingService.getLatitudeLongitudeForAddress(data);
			Assert.fail('The service should have returned an exception.');
		}
		catch (GoogleGeoCodingExceptions.ParameterException e)
		{
			// Expected exception.
		}
	}

	@isTest
	private static void missingRequest()
	{
		HttpResponse mock_response = new HttpResponse();
		mock_response.setBody(String.join(getResponseJson(), ''));

		GoogleGeoCodingGetCallout.setMockHttpResponse(mock_response);
		GoogleGeoCodingService.setIsTest();

		try
		{
			GoogleGeoCodingService.getLatitudeLongitudeForAddress(null);
			Assert.fail('An exception should have occurred.');
		}
		catch (GoogleGeoCodingExceptions.ParameterException e) {
			// Exception expected.
		}
	}

	private static List<String> getResponseJson()
	{
		List<String> sb = new List<String>();

		sb.add('{');
		sb.add('   "results" : [');
		sb.add('      {');
		sb.add('         "address_components" : [');
		sb.add('            {');
		sb.add('               "long_name" : "1600",');
		sb.add('               "short_name" : "1600",');
		sb.add('               "types" : [ "street_number" ]');
		sb.add('            },');
		sb.add('            {');
		sb.add('               "long_name" : "Amphitheatre Pkwy",');
		sb.add('               "short_name" : "Amphitheatre Pkwy",');
		sb.add('               "types" : [ "route" ]');
		sb.add('            },');
		sb.add('            {');
		sb.add('               "long_name" : "Mountain View",');
		sb.add('               "short_name" : "Mountain View",');
		sb.add('               "types" : [ "locality", "political" ]');
		sb.add('            },');
		sb.add('            {');
		sb.add('               "long_name" : "Santa Clara County",');
		sb.add('               "short_name" : "Santa Clara County",');
		sb.add('               "types" : [ "administrative_area_level_2", "political" ]');
		sb.add('            },');
		sb.add('            {');
		sb.add('               "long_name" : "California",');
		sb.add('               "short_name" : "CA",');
		sb.add('               "types" : [ "administrative_area_level_1", "political" ]');
		sb.add('            },');
		sb.add('            {');
		sb.add('               "long_name" : "United States",');
		sb.add('               "short_name" : "US",');
		sb.add('               "types" : [ "country", "political" ]');
		sb.add('            },');
		sb.add('            {');
		sb.add('               "long_name" : "94043",');
		sb.add('               "short_name" : "94043",');
		sb.add('               "types" : [ "postal_code" ]');
		sb.add('            }');
		sb.add('         ],');
		sb.add('         "formatted_address" : "1600 Amphitheatre Parkway, Mountain View, CA 94043, USA",');
		sb.add('         "geometry" : {');
		sb.add('            "location" : {');
		sb.add('               "lat" : 37.4224764,');
		sb.add('               "lng" : -122.0842499');
		sb.add('            },');
		sb.add('            "location_type" : "ROOFTOP",');
		sb.add('            "viewport" : {');
		sb.add('               "northeast" : {');
		sb.add('                  "lat" : 37.4238253802915,');
		sb.add('                  "lng" : -122.0829009197085');
		sb.add('               },');
		sb.add('               "southwest" : {');
		sb.add('                  "lat" : 37.4211274197085,');
		sb.add('                  "lng" : -122.0855988802915');
		sb.add('               }');
		sb.add('            }');
		sb.add('         },');
		sb.add('         "place_id" : "ChIJ2eUgeAK6j4ARbn5u_wAGqWA",');
		sb.add('         "types" : [ "street_address" ]');
		sb.add('      }');
		sb.add('   ],');
		sb.add('   "status" : "OK"');
		sb.add('}');

		return sb;
	}

	public static GoogleAddress getAddress()
	{
        return new GoogleAddress().setStreet('1600 Amphitheatre Pkwy.')
                                .setCity('Mountain View')
                                .setState('CA')
                                .setPostalCode('94043')
                                .setCountry('USA');
	}
}