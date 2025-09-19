@IsTest
private class GreetingsConsumerTest
{
	// Unit tests that include indeterminate factors are challenging to test. In the
	// GreetingsConsumer sense, the supporting code, which we don't want to test, uses
	// a date based component which affects the expected value for the test.
	// Often developers will directly change the business logic to do something
	// different when a test is executing the code, i.e. Test.isTestRunning(), which
	// introduces unwanted code and creates distant dependency for the test.  It
	// would be cleaner and less rigid to use a mock testing approach, illustrated here.
	@IsTest
	static void getWelcomeMessageText()
	{
		String name = 'Anania';

		Application.Logic.setMock(IGreetings.class, new MockGreetings());

		String msg = new GreetingsConsumer().getWelcomeMessageText(name);

		Assert.isTrue(msg.startsWith('Thank you, ' + name));  // Message begins using the proper name
		Assert.isTrue(msg.contains('fabulous service'));      // assures an important part of the content, for example
		Assert.isTrue(msg.endsWith('Happy day_of_week!!!'));  // We don't need logic dealing with date details
	}

	public class MockGreetings
		implements IGreetings
	{
		public String getGreeting()
		{
			return getGreeting(null);
		}

		public String getGreeting(String name)
		{
			return 'test';
		}

		public String getGreetingForDayOfWeek()
		{
			return 'Happy day_of_week!!!';
		}
	}
}