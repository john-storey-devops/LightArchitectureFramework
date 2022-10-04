public inherited sharing class Greetings
	implements IGreetings
{
	public String getGreeting()
	{
		return getGreeting(null);
	}

	public String getGreeting(String name)
	{
		if (String.isBlank(name))
		{
			name = 'world';
		}

		return 'Hello ' + name + '!!!';
	}

	public String getGreetingForDayOfWeek()
	{
		return 'Happy' + Datetime.now().format('EEEE') + '!!!';
	}
}