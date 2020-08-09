public inherited sharing class GenericPlatformEventsConsumer
    extends PlatformEventAbstractConsumer
{
    /************************************************************
     * This method is only needed for this sample code.
     * 
     * Normally the generation of the event would occur in the
     * related SObject or a different place in the code base.
    *************************************************************/
    public static void GeneratePlatformEvent()
    {
        IafEvent__e platformEventbus = new IafEvent__e();

        platformEventbus.EventName__c = 'please_say_hello';
        Database.SaveResult sr = EventBus.publish(platformEventbus);
        System.debug(JSON.serializePretty(sr));

        System.assertEquals(true, sr.isSuccess());
    }

    public override void runInProcess()
    {
        System.debug('Hello World!!!');
    }
}
