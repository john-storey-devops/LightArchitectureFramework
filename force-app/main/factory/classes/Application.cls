public class Application
{

    public static Map<String, SObjectType> SObjectTypesByNameMap = Schema.getGlobalDescribe();

    public static DomainClass Domain = new DomainClass();
    public static SelectorClass Selector = new SelectorClass();
    public static UnitOfWorkClass Unit_Of_Work = new UnitOfWorkClass();

    public class DomainClass
    {

        private Map<SObjectType, DomainDefinitionData> domainDefinitionMap = new Map<SObjectType, DomainDefinitionData>();
        private Map<SObjectType, IDomain> domainInstanceMap = new Map<SObjectType, IDomain>();
        private Map<SObjectType, IDomain> mockDomainMap = new Map<SObjectType, IDomain>();

        /*
         *    This should be assigned True by a unit test exercising all of the triggers so that triggers have non-zero coverage.
         */
        @TestVisible
        private Boolean triggerCoverageOnly = false;

        public IDomain newInstance(SObjectType sobj_type)
        {

            // Exit the process if the usage is for trigger class coverage.
            if (triggerCoverageOnly) {
                return new DoNothingDomainClass();
            }

            // If a mock instance exists, provide it to the consumer.
            if (mockDomainMap.containsKey(sobj_type)) {
                return mockDomainMap.get(sobj_type);
            }

            if (domainDefinitionMap.containsKey(sobj_type)) {

                // If the domain is inactive via configuration
                // return the do-nothing version.
                if (!domainDefinitionMap.get(sobj_type).active) {
                    domainInstanceMap.put(sobj_type, new DoNothingDomainClass());
                }
                else if (!domainInstanceMap.containsKey(sobj_type)) {
                    Type domainClass = domainDefinitionMap.get(sobj_type).domain_class;
                    domainInstanceMap.put(sobj_type, (IDomain) domainClass.newInstance());
                }
            }
            else {
                throw new ApplicationException('[Domain] SObjectType doesn\'t have a defined, trigger-handler implementation.');
            }

            return domainInstanceMap.get(sobj_type);
        }

        @TestVisible
        private void setMock(SObjectType sobj_type, IDomain mock_domain)
        {
            mockDomainMap.put(sobj_type, mock_domain);
        }

        public DomainClass()
        {

            List<ApplicationDomainBinding__mdt> definitionList = [
                SELECT
                    Active__c,
                    BindingSObject__c,
                    BindingSObject__r.QualifiedApiName,
                    BindingSObjectAlternate__c,
                    To__c
                FROM ApplicationDomainBinding__mdt
            ];

            for (ApplicationDomainBinding__mdt def : definitionList) {
                DomainDefinitionData def_data = new DomainDefinitionData(def);
                domainDefinitionMap.put(def_data.sobj_type, def_data);
            }
        }
    }

    public class SelectorClass
    {

        private Map<SObjectType, SelectorDefinitionData> selectorDefinitionMap = new Map<SObjectType, SelectorDefinitionData>();
        private Map<SObjectType, ISObjectSelector> selectorInstanceMap = new Map<SObjectType, ISObjectSelector>();
        private Map<SObjectType, ISObjectSelector> mockSelectorMap = new Map<SObjectType, ISObjectSelector>();

        public ISObjectSelector newInstance(SObjectType sobj_type)
        {

            // If a mock instance exists, provide it to the consumer.
            if (mockSelectorMap.containsKey(sobj_type))
            {
                return mockSelectorMap.get(sobj_type);
            }

            if (selectorDefinitionMap.containsKey(sobj_type))
            {
                if (!selectorInstanceMap.containsKey(sobj_type))
                {
                    selectorInstanceMap.put(sobj_type, ((ISObjectSelector) selectorDefinitionMap.get(sobj_type).selector_class.newInstance()));
                }
            }
            else
            {
                throw new ApplicationException('[Selector] SObjectType doesn\'t have a defined, selector implementation.');
            }

            return selectorInstanceMap.get(sobj_type);
        }

        @TestVisible
        private void setMock(SObjectType sobj_type, ISObjectSelector mock_selector)
        {

            mockSelectorMap.put(sobj_type, mock_selector);
        }

        public SelectorClass() {

            List<ApplicationSelectorBinding__mdt> definitionList =
            [
                SELECT
                    BindingSObject__c,
                    BindingSObject__r.QualifiedApiName,
                    BindingSObjectAlternate__c,
                    To__c
                FROM ApplicationSelectorBinding__mdt
            ];

            for (ApplicationSelectorBinding__mdt def : definitionList)
            {
                SelectorDefinitionData def_data = new SelectorDefinitionData(def);
                selectorDefinitionMap.put(def_data.sobj_type, def_data);
            }
        }
    }

    public class UnitOfWorkClass
    {
        private Map<String, IUnitOfWork> unitOfWorkInstanceMap = new Map<String, IUnitOfWork>();

        public IUnitOfWork newInstance(SObjectType sobjType, UnitOfWorkArtifacts.DmlOperation dmlOperation)
        {
            String key = makeKey(sobjType, dmlOperation);

            if (!unitOfWorkInstanceMap.containsKey(key))
            {
                unitOfWorkInstanceMap.put(key, UnitOfWork.newInstance(sobjType, dmlOperation));
            }

            return unitOfWorkInstanceMap.get(key);
        }

        @TestVisible
        private void setMock(IUnitOfWork mock_unitOfWork)
        {
            unitOfWorkInstanceMap.put(makeKey(mock_unitOfWork), mock_unitOfWork);
        }

        private String makeKey(IUnitOfWork uow)
        {
            return makeKey(uow.getSObjectType(), uow.getDmlOperation());
        }

        private String makeKey(SObjectType sobjType, UnitOfWorkArtifacts.DmlOperation dmlOperation)
        {
            return
                sobjType.getDescribe().getKeyPrefix()
                + '|' +
                dmlOperation.name();
        }
    }

    private class SelectorDefinitionData
    {

        public SObjectType sobj_type = null;
        public Type selector_class = null;

        public SelectorDefinitionData(ApplicationSelectorBinding__mdt def) {

            if (def.BindingSObject__c != null) {
                sobj_type = Application.SObjectTypesByNameMap.get(def.BindingSObject__r.QualifiedApiName);
            }
            else if (Application.SObjectTypesByNameMap.containsKey(def.BindingSObjectAlternate__c.toLowerCase())) {
                sobj_type = Application.SObjectTypesByNameMap.get(def.BindingSObjectAlternate__c.toLowerCase());
            }
            else {
                throw new ApplicationException('[Selector] Binding SObject not specified.');
            }

            if (String.isNotBlank(def.To__c)) {
                selector_class = Type.forName(def.To__c);
            }
            else {
                throw new ApplicationException('[Selector] Related Apex class not specified.');
            }
        }
    }

    private class DomainDefinitionData
    {

        public SObjectType sobj_type = null;
        public Type domain_class = null;
        public Boolean active = true;

        public DomainDefinitionData(ApplicationDomainBinding__mdt def) {

            if (def.BindingSObject__c != null) {
                sobj_type = Application.SObjectTypesByNameMap.get(def.BindingSObject__r.QualifiedApiName);
            }
            else if (Application.SObjectTypesByNameMap.containsKey(def.BindingSObjectAlternate__c.toLowerCase())) {
                sobj_type = Application.SObjectTypesByNameMap.get(def.BindingSObjectAlternate__c.toLowerCase());
            }
            else {
                throw new ApplicationException('[Domain] Binding SObject not specified.');
            }

            if (String.isNotBlank(def.To__c)) {
                domain_class = Type.forName(def.To__c);
            }
            else {
                throw new ApplicationException('[Domain] Related Apex class not specified.');
            }

            this.active = def.Active__c;
        }
    }

    public class ApplicationException
        extends Exception
    {}
}
