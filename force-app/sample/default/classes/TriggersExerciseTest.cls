@IsTest
public class TriggersExerciseTest {
    
    @IsTest
    private static void Account() {
        Application.TriggerHandler.triggerCoverageOnly = true;
        insert new Account(Name='joe');
    }
}
