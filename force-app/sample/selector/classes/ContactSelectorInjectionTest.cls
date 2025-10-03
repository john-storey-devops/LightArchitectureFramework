@IsTest
private class ContactSelectorInjectionTest
{
    @IsTest
    static void selectQuery_WHEN_HappyValueProvided_EXPECT_SuccessfulExecution()
    {
        Test.startTest();
        ContactSelector.newInstance()
            .addAdditionalSObjectFields(new List<SObjectField> {Contact.LastName})
            .selectWithInjectable(
            ContactSelectorInjection.class,
            ContactSelectorInjectionArguments.newInstance('Hello%'));
        Test.stopTest();
    }
}