@IsTest
private class DEV_WidgetsSelectorMethodTest
{
    @IsTest
	static void injectedQuery_WHEN_HasMatchingRecord_THEN_ThatRecordIsReturned()
	{
        List<DEV_Widget__c> acctList = new List<DEV_Widget__c> {
                new DEV_Widget__c(
                    DEV_Description__c = 'Hello world'
                ),
                new DEV_Widget__c(
                    DEV_Description__c = 'Good day sir'
                )
        };
        Database.insert(acctList);

        DEV_WidgetsSelectorMethod.Parameters queryParams = new DEV_WidgetsSelectorMethod.Parameters();
        queryParams.descriptionShouldContainLike = '%sir';

        DEV_WidgetsSelector selector = new DEV_WidgetsSelector();

        Test.startTest();
        List<DEV_Widget__c> widgetsReturned =
                selector.selectInjection(
                        DEV_WidgetsSelectorMethod.class,
                        queryParams
                );
        Test.stopTest();

        DEV_Widget__c widgetToCheck = widgetsReturned[0];
        System.Assert.isTrue(
                widgetToCheck.DEV_Description__c.containsIgnoreCase('sir'),
                'The returned record does not contain the desired, expected text.'
        );
	}
}