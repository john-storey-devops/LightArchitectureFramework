public class Application {

    public SelectorClass Selector = new SelectorClass();
    public TriggerClass TriggerHandler = new TriggerClass();

    private class TriggerClass {

        private Map<SObjectType, TriggerDefinitionData> triggerHandlerDefinitionMap = new Map<SObjectType, TriggerDefinitionData>();
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
                if (triggerHandlerDefinitionMap.get(sobj_type).disabled) {
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

            /********************************************************************************************
             *   Place Trigger Handler definitions here as exemplified by the following comment.
             *******************************************************************************************/
            // triggerHandlerDefinitionMap.put(Account.SObjectType, Account_TH.class);
        }
    }

    private class SelectorClass {

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

            /********************************************************************************************
             *   Place Selector definitions here as exemplified by the following comment.
             *******************************************************************************************/
            // selectorDefinitionMap.put(Account.SObjectType, Account_SEL.class);
        }
    }

    private class SelectorDefinitionData {
        public SObjectType sobj_type = null;
        public Type selector_class = null;

        public SelectorDefinitionData(SObjectType sobj_type, Type selector_class) {
            this.sobj_type = sobj_type;
            this.selector_class = selector_class;
        }
    }

    private class TriggerDefinitionData {
        public SObjectType sobj_type = null;
        public Type trigger_class = null;
        public Boolean disabled = false;

        public TriggerDefinitionData(SObjectType sobj_type, Type trigger_class) {
            this.sobj_type = sobj_type;
            this.trigger_class = trigger_class;
            this.disabled = false;
        }
    }

    public class ApplicationException
        extends Exception {}
}
