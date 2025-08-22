public with sharing class DEV_WidgetsSelectorMethod
    extends AbstractSelectorMethodInjectable
    implements ISelectorMethodInjectable
{
    public List<SObject> selectQuery()
    {
        Parameters params = (Parameters)getParams();
        String descriptionLike = params.descriptionShouldContainLike;
        return Database.query(newQueryFactory().setCondition(DEV_Widget__c.DEV_Description__c + ' LIKE :descriptionLike').toSOQL());
    }

    public class Parameters
            implements ISelectorMethodParameterable
    {
        public String descriptionShouldContainLike;
    }
}