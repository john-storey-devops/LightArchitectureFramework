@IsTest
public class TestUtils
{
	private static Integer fakeIdCount = 0;

	public static Id mockId(SObjectType t)
	{
		String keyPrefix = t.getDescribe().getKeyPrefix();
		String fakeId = (fakeIdCount++).format().leftPad(12, '0');
		return Id.valueOf(keyPrefix + fakeId);
	}
}