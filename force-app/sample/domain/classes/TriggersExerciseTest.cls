@IsTest
public class TriggersExerciseTest {
    
    @IsTest
    private static void Account() {
        Application.Domain.triggerCoverageOnly = true;
        insert new Account(Name='joe');
    }
}
