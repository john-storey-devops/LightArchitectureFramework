public inherited sharing class GreetingsConsumer
{
	public String getWelcomeMessageText(String name)
	{
		if (String.isBlank(name))
		{
			throw new GreetingsConsumerException('Name is required');
		}

		String dayOfWeekGreeting = ((IGreetings) Application.Logic.newInstance(IGreetings.class)).getGreetingForDayOfWeek();
		return 'Thank you, ' + name + ', for signing-up for our fabulous service.  ' + dayOfWeekGreeting;
	}

	public class GreetingsConsumerException
		extends Exception
	{
		// Intentionally blank
	}
}