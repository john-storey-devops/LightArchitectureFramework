/**
 *  UtilsTest is all unit tests pertaining to the Utils class
 *
 *  @see Utils
 */
@isTest
private class UtilsTest
{
    @IsTest
    static void testOrgValueIsAvailable()
    {
        Assert.isNotNull( Utils.org );
    }
}