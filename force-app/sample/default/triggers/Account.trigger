Trigger Account
    on Account
(
    Before Insert,
    Before Update,
    After Insert,
    After Update
) {
    ((ITriggerHandler) Application.Domain.newInstance(Account.SObjectType)).handleTrigger();
}
