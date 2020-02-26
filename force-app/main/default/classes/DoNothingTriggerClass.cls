public class DoNothingTriggerClass
    implements ITriggerHandler {

    public static ITriggerHandler newTriggerInstance() {
        return new DoNothingTriggerClass();
    }

    public void handleTrigger() {
        // Intentionally blank.
    }
}
