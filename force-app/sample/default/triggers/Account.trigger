Trigger Account
    on Account
(
    Before Insert,
    Before Update,
    After Insert,
    After Update
) {
    Application.TriggerHandler.newTriggerHandler(Account.SObjectType).handleTrigger();
}
