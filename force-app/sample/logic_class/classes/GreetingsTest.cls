@IsTest
private class GreetingsTest
{
	@IsTest
	static void getGreetingWithDefinedImplementation()
    {
        IGreetings g = (IGreetings) Application.Logic.newInstance(IGreetings.class);
        Assert.areEqual('Hello world!!!', g.getGreeting());
        Assert.areEqual('Hello everyone!!!', g.getGreeting('everyone'));
    }

	@IsTest
	static void getGreetingWithMockImplementation()
	{
		Application.Logic.setMock(IGreetings.class, new MockGreetings());
		IGreetings g = (IGreetings) Application.Logic.newInstance(IGreetings.class);
		Assert.areEqual('test', g.getGreeting());
		Assert.areEqual('test', g.getGreeting('everyone'));
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