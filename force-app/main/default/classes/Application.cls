public class Application {

    public static Map<String, SObjectType> SObjectTypesByNameMap = Schema.getGlobalDescribe();

    public static SelectorClass Selector = new SelectorClass();
    public static TriggerClass TriggerHandler = new TriggerClass();

    public class TriggerClass {

        private Map<SObjectType, TriggerHandlerDefinitionData> triggerHandlerDefinitionMap = new Map<SObjectType, TriggerHandlerDefinitionData>();
        private Map<SObjectType, ITriggerHandler> triggerHandlerInstanceMap = new Map<SObjectType, ITriggerHandler>();
        private Map<SObjectType, ITriggerHandler> mockTriggerHandlerMap = new Map<SObjectType, ITriggerHandler>();

        /*
         *    This should be assigned True by a unit test exercising all of the triggers so that triggers have non-zero coverage.
         */
        @TestVisible
        private Boolean triggerCoverageOnly = false;

        public ITriggerHandler newTriggerHandler(SObjectType sobj_type) {

            // Exit the process if the usage is for trigger class coverage.
            if (triggerCoverageOnly) {
                return new DoNothingTriggerClass();
            }

            // If a mock instance exists, provide it to the consumer.
            if (mockTriggerHandlerMap.containsKey(sobj_type)) {
                return mockTriggerHandlerMap.get(sobj_type);
            }

            if (triggerHandlerDefinitionMap.containsKey(sobj_type)) {

                // If the trigger handler is inactive via configuration
                // return the do-nothing version.
                if (!triggerHandlerDefinitionMap.get(sobj_type).active) {
                    triggerHandlerInstanceMap.put(sobj_type, new DoNothingTriggerClass());
                }
                else if (!triggerHandlerInstanceMap.containsKey(sobj_type)) {
                    triggerHandlerInstanceMap.put(sobj_type, ((ITriggerHandler) triggerHandlerDefinitionMap.get(sobj_type).trigger_class.newInstance()).newTriggerInstance());
                }
            }
            else {
                throw new ApplicationException('[TriggerHandler] SObjectType doesn\'t have a defined, trigger-handler implementation.');
            }

            return triggerHandlerInstanceMap.get(sobj_type);
        }

        public void setMock(SObjectType sobj_type, ITriggerHandler mock_handler) {

            mockTriggerHandlerMap.put(sobj_type, mock_handler);
        }

        public TriggerClass() {

            List<ApplicationTriggerHandlerBinding__mdt> definitionList = [
                select
                    Active__c,
                    BindingSObject__c,
                    BindingSObjectAlternate__c,
                    To__c
                from ApplicationTriggerHandlerBinding__mdt
            ];

            for (ApplicationTriggerHandlerBinding__mdt def : definitionList) {
                TriggerHandlerDefinitionData def_data = new TriggerHandlerDefinitionData(def);
                triggerHandlerDefinitionMap.put(def_data.sobj_type, def_data);
            }
        }
    }

    public class SelectorClass {

        private Map<SObjectType, SelectorDefinitionData> selectorDefinitionMap = new Map<SObjectType, SelectorDefinitionData>();
        private Map<SObjectType, ISObjectSelector> selectorInstanceMap = new Map<SObjectType, ISObjectSelector>();
        private Map<SObjectType, ISObjectSelector> mockSelectorMap = new Map<SObjectType, ISObjectSelector>();

        public ISObjectSelector newSelector(SObjectType sobj_type) {

            // If a mock instance exists, provide it to the consumer.
            if (mockSelectorMap.containsKey(sobj_type)) {
                return mockSelectorMap.get(sobj_type);
            }

            if (selectorDefinitionMap.containsKey(sobj_type)) {
                if (!selectorInstanceMap.containsKey(sobj_type)) {
                    selectorInstanceMap.put(sobj_type, ((ISObjectSelector) selectorDefinitionMap.get(sobj_type).selector_class.newInstance()));
                }
            }
            else {
                throw new ApplicationException('[Selector] SObjectType doesn\'t have a defined, selector implementation.');
            }

            return selectorInstanceMap.get(sobj_type);
        }

        public void setMock(SObjectType sobj_type, ISObjectSelector mock_selector) {

            mockSelectorMap.put(sobj_type, mock_selector);
        }

        public SelectorClass() {

            List<ApplicationSelectorBinding__mdt> definitionList = [
                select
                    BindingSObject__c,
                    BindingSObjectAlternate__c,
                    To__c
                from ApplicationSelectorBinding__mdt
            ];

            for (ApplicationSelectorBinding__mdt def : definitionList) {
                SelectorDefinitionData def_data = new SelectorDefinitionData(def);
                selectorDefinitionMap.put(def_data.sobj_type, def_data);
            }
        }
    }

    private class SelectorDefinitionData {

        public SObjectType sobj_type = null;
        public Type selector_class = null;

        public SelectorDefinitionData(ApplicationSelectorBinding__mdt def) {

            if (def.BindingSObject__c != null) {
                sobj_type = Application.SObjectTypesByNameMap.get(def.BindingSObject__c);
            }
            else if (Application.SObjectTypesByNameMap.containsKey(def.BindingSObjectAlternate__c)) {
                sobj_type = Application.SObjectTypesByNameMap.get(def.BindingSObjectAlternate__c);
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

    private class TriggerHandlerDefinitionData {

        public SObjectType sobj_type = null;
        public Type trigger_class = null;
        public Boolean active = true;

        public TriggerHandlerDefinitionData(ApplicationTriggerHandlerBinding__mdt def) {

            if (def.BindingSObject__c != null) {
                sobj_type = Application.SObjectTypesByNameMap.get(def.BindingSObject__c);
            }
            else if (Application.SObjectTypesByNameMap.containsKey(def.BindingSObjectAlternate__c)) {
                sobj_type = Application.SObjectTypesByNameMap.get(def.BindingSObjectAlternate__c);
            }
            else {
                throw new ApplicationException('[TriggerHandler] Binding SObject not specified.');
            }

            if (String.isNotBlank(def.To__c)) {
                trigger_class = Type.forName(def.To__c);
            }
            else {
                throw new ApplicationException('[TriggerHandler] Related Apex class not specified.');
            }

            this.active = !def.Active__c;
        }
    }

    public class ApplicationException
        extends Exception {}
}
