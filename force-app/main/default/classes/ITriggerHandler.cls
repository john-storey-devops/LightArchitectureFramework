public interface ITriggerHandler {
    void handleTrigger();
    ITriggerHandler newTriggerInstance();
}
