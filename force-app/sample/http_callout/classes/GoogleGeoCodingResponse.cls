public class GoogleGeoCodingResponse
    implements BaseCallout.CalloutResponse
{

    public List<Results> results = new List<Results>();
    public String status;
    public String error_message;

    public integer getTotalNumberOfRecordsFound()
    {
        return this.results == null ? 0 : this.results.size();
    }

    public class Results
    {
        public List<Address_components> address_components;
        public String formatted_address;
        public Geometry geometry;
        public String place_id;
        public List<String> types;
    }

    public class Address_components
    {
        public String long_name;
        public String short_name;
        public List<String> types;
    }

    public class Geometry
    {
        public Location location;
        public String location_type;
        public Viewport viewport;
    }

    public class Viewport
    {
        public Location northeast;
        public Location southwest;
    }

    public class Location
    {
        public Double lat;
        public Double lng;
    }

    public static GoogleGeoCodingResponse parse(String json)
    {
        return (GoogleGeoCodingResponse) System.JSON.deserialize(json, GoogleGeoCodingResponse.class);
    }
}