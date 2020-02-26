@IsTest
public class AccountSelectorTest {
    
    @IsTest
    private static void InertUsage() {
        AccountSelector.newInstance().selectById(new Set<Id>());
    }
}
