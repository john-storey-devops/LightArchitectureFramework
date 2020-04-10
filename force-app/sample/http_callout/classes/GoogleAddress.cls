public class GoogleAddress
{
    private String street;
    private String city;
    private String state;
    private String postalCode;
    private String country;

    public GoogleAddress setStreet( final string street )
    {
    	this.street = street;
    	return this;
    }

    public GoogleAddress setCity( final string city )
    {
    	this.city = city;
    	return this;
    }

    public GoogleAddress setState( final string state )
    {
    	this.state = state;
    	return this;
    }

    public GoogleAddress setPostalCode( final string postalCode )
    {
    	this.postalCode = postalCode;
    	return this;
    }

    public GoogleAddress setCountry( final string country )
    {
    	this.country = country;
    	return this;
    }

    public String getStreet()
    {
    	return this.street;
    }

    public String getCity()
    {
    	return this.city;
    }

    public String getState()
    {
    	return this.state;
    }

    public String getPostalCode()
    {
    	return this.postalCode;
    }

    public String getCountry()
    {
    	return this.country;
    }

	public Boolean isValidAddress()
	{
		// Data requirements: Street && State && Country && (City || Postal Code)
		return
			String.isNotEmpty(this.getStreet()) &&
			String.isNotEmpty(this.getState()) &&
			String.isNotEmpty(this.getCountry()) &&
			(
				String.isNotEmpty(this.getCity()) ||
				String.isNotEmpty(this.getPostalCode())
			);
	}
}