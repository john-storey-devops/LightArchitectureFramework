@IsTest
public class DoNothingDomainClassTest {
    
    @IsTest
    private static void Exercise() {

        /*
         *    This class simply covers its interface and has no functionality
         *    therefore this testing is for coverage primarily.
         */

         DoNothingDomainClass inert = (DoNothingDomainClass) DoNothingDomainClass.newInstance();
         Assert.isNotNull(inert);
         inert.handleTrigger();
         Assert.isNull(inert.domainSObjectType());
    }
}
