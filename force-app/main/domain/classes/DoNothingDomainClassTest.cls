@IsTest
public class DoNothingDomainClassTest {
    
    @IsTest
    private static void Exercise() {

        /*
         *    This class simply covers its interface and has no functionality
         *    therefore this testing is for coverage primarily.
         */

         DoNothingDomainClass inert = (DoNothingDomainClass) DoNothingDomainClass.newInstance();
         System.assert(inert != null);
         inert.handleTrigger();
         System.assertEquals(null, inert.domainSObjectType());
    }
}
