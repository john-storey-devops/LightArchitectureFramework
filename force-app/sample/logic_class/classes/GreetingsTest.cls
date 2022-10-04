@IsTest
private class GreetingsTest
{
	@IsTest
	static void getGreetingWithDefinedImplementation()
    {
        IGreetings g = (IGreetings) Application.Logic.newInstance(IGreetings.class);
        System.assertEquals('Hello world!!!', g.getGreeting());
        System.assertEquals('Hello everyone!!!', g.getGreeting('everyone'));
    }

	@IsTest
	static void getGreetingWithMockImplementation()
	{
		Application.Logic.setMock(IGreetings.class, new MockGreetings());
		IGreetings g = (IGreetings) Application.Logic.newInstance(IGreetings.class);
		System.assertEquals('test', g.getGreeting());
		System.assertEquals('test', g.getGreeting('everyone'));
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