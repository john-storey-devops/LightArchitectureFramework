/**
 * Copyright (c) 2020, John M. Daniel & John Storey
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the John M. Daniel, nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

public class PlatformEventDistributor
{
    private enum MatcherRules
    {
        MatchEventBusAndCategoryAndEventName,
        MatchEventBusAndCategory,
        MatchEventBusAndEventName,
        MatchEventBus
    }

    private static string CATEGORY_FIELD_NAME = 'Category__c'.toLowerCase();
    private static string EVENT_NAME_FIELD_NAME = 'EventName__c'.toLowerCase();

    private static Schema.DescribeSObjectResult Platform_Event_Bus_Describe = null;
    private static Set<String> Platform_Event_Bus_Available_Fields_Set = null;

    private Map<String, List<PlatformEvents_Subscription__mdt>> eventBusToConfigurationMap = new Map<String, List<PlatformEvents_Subscription__mdt>>();

    @TestVisible
    private List<Id> jobIdList = new List<Id>();

    public PlatformEventDistributor()
    {
        Map<String, List<PlatformEvents_Subscription__mdt>> eventBusToConfigurationMap = new Map<String, List<PlatformEvents_Subscription__mdt>>();

        list<PlatformEvents_Subscription__mdt> bindings = 
        [
            select
                Id,
                Consumer__c,
                Event__c,
                EventBus__c,
                EventCategory__c,
                ExecuteSynchronous__c,
                IsActive__c,
                MatcherRule__c
            from PlatformEvents_Subscription__mdt
        ];

        for (PlatformEvents_Subscription__mdt peSubscriber : bindings)
        {
            if (!eventBusToConfigurationMap.containsKey(peSubscriber.EventBus__c))
            {
                eventBusToConfigurationMap.put(peSubscriber.EventBus__c, new List<PlatformEvents_Subscription__mdt>());
            }

            eventBusToConfigurationMap.get(peSubscriber.EventBus__c).add(peSubscriber);

            System.debug(LoggingLevel.DEBUG, eventBusToConfigurationMap);
        }
    }

    public static void triggerHandler()
    {
        if (Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert)
        {
            new PlatformEventDistributor().triggerHandler(trigger.new);
        }
    }

    @TestVisible
    private void triggerHandler(List<SObject> events)
    {
        System.debug(LoggingLevel.DEBUG, 'events:\n' + events);

        if (events == null || events.isEmpty())
        {
            return;
        }

        captureEventSchemaInformation(events);

        List<PlatformEvents_Subscription__mdt> eventSubscriptionRecords = getEventSubscribers(events);
        List<SObject> eventBatchForSubscriber = new List<SObject>();

        // for each PlatformEvents_Subscription__mdt record, instantiate the Apex class found in the Consumer field
        for ( PlatformEvents_Subscription__mdt subscriptionRecord : eventSubscriptionRecords )
        {
            eventBatchForSubscriber.clear();

            // sort through the events and only select the ones that this subscriber is interested.
            for ( SObject event : events )
            {
                if (eventMatchesSubscriberCriteria(event, subscriptionRecord))
                {
                    eventBatchForSubscriber.add( event );
                }
            }

            System.debug(LoggingLevel.DEBUG, 'eventBatchForSubscriber:\n' + eventBatchForSubscriber);

            jobIdList = dispatchEventsToInterestedSubscribers(eventBatchForSubscriber, subscriptionRecord);
        }

        System.debug(LoggingLevel.DEBUG, 'jobIdList: ' + jobIdList);
    }

    private static void captureEventSchemaInformation(List<SObject> events)
    {
        Platform_Event_Bus_Describe = events.getSobjectType().getDescribe(SObjectDescribeOptions.DEFERRED);
        Platform_Event_Bus_Available_Fields_Set = Platform_Event_Bus_Describe.fields.getMap().keyset();
    }

    private static List<Id> dispatchEventsToInterestedSubscribers(List<SObject> eventBatchForSubscriber, PlatformEvents_Subscription__mdt subscriptionRecord)
    {
        List<Id> jobIdList = new List<Id>();
        
        if (eventBatchForSubscriber.isEmpty()) return jobIdList;

        // now that the events have been sorted for this specific subscription, distribute them to that subscriber
        try
        {
            System.debug(LoggingLevel.DEBUG, 'attempting to construct the consumer');
            System.debug(LoggingLevel.DEBUG, 'subscriptionRecord.Consumer__c:\n' + subscriptionRecord.Consumer__c);

            // verify that the class exists and that class implements the IEventsConsumer interface
            IEventsConsumer consumer = (IEventsConsumer)(Type.forName( subscriptionRecord.Consumer__c ).newInstance());

            System.debug(LoggingLevel.DEBUG, 'successfully constructed');

            Id thisJob = subscriptionRecord.ExecuteSynchronous__c != null && subscriptionRecord.ExecuteSynchronous__c
                ? consumer.setEvents(eventBatchForSubscriber).setRunSynchronous().run()
                : consumer.setEvents(eventBatchForSubscriber).run();
            
            if (thisJob != null) {
                jobIdList.add( thisJob );
            }

        }
        catch (Exception e)
        {
            system.debug(LoggingLevel.DEBUG, e);
            System.debug(LoggingLevel.DEBUG, subscriptionRecord);
            System.debug(LoggingLevel.DEBUG, eventBatchForSubscriber);
        }

        return jobIdList;
    }

    private static Boolean eventMatchesSubscriberCriteria(SObject event, PlatformEvents_Subscription__mdt subscriptionRecord)
    {
        Boolean answer = false;

        System.debug(
            LoggingLevel.DEBUG, 
            'Comparing ...\n' +
            'Platform_Event_Bus_Available_Fields_Set:\n\t' + new List<String>(Platform_Event_Bus_Available_Fields_Set) + '\n' +
            'Platform_Event_Bus_Describe.getName(): ' + Platform_Event_Bus_Describe.getName() + '\n' +
            'subscriptionRecord:\n\t' + subscriptionRecord + '\n' +
            'event:\n\t' + event);

        // Match on Category__c and EventName__c
        if ( Platform_Event_Bus_Describe.getName().equalsIgnoreCase( subscriptionRecord.EventBus__c )
            && MatcherRules.MatchEventBusAndCategoryAndEventName.name().equalsIgnoreCase( subscriptionRecord.MatcherRule__c )
            && Platform_Event_Bus_Available_Fields_Set.contains( CATEGORY_FIELD_NAME )
            && Platform_Event_Bus_Available_Fields_Set.contains( EVENT_NAME_FIELD_NAME )
            && subscriptionRecord.EventCategory__c.equalsIgnoreCase( (String)event.get( CATEGORY_FIELD_NAME ) )
            && subscriptionRecord.Event__c.equalsIgnoreCase( (String)event.get( EVENT_NAME_FIELD_NAME ) ) )
        {
            System.debug(LoggingLevel.DEBUG, 'match #1');
            answer = true;
        }

        // Match on Category__c
        else if ( Platform_Event_Bus_Describe.getName().equalsIgnoreCase( subscriptionRecord.EventBus__c )
            && MatcherRules.MatchEventBusAndCategory.name().equalsIgnoreCase( subscriptionRecord.MatcherRule__c )
            && Platform_Event_Bus_Available_Fields_Set.contains( CATEGORY_FIELD_NAME )
            && subscriptionRecord.EventCategory__c.equalsIgnoreCase( (String)event.get( CATEGORY_FIELD_NAME ) ) )
        {
            System.debug(LoggingLevel.DEBUG, 'match #2');
            answer = true;
        }

        // Match on EventName__c
        else if ( Platform_Event_Bus_Describe.getName().equalsIgnoreCase( subscriptionRecord.EventBus__c )
            && MatcherRules.MatchEventBusandEventName.name().equalsIgnoreCase( subscriptionRecord.MatcherRule__c )
            && Platform_Event_Bus_Available_Fields_Set.contains( EVENT_NAME_FIELD_NAME )
            && subscriptionRecord.Event__c.equalsIgnoreCase( (String)event.get( EVENT_NAME_FIELD_NAME ) ) )
        {
            System.debug(LoggingLevel.DEBUG, 'match #3');
            answer = true;
        }

        // Match sole because it is an event on this specific platform event bus
        else if ( Platform_Event_Bus_Describe.getName().equalsIgnoreCase( subscriptionRecord.EventBus__c )
            && MatcherRules.MatchEventBus.name().equalsIgnoreCase( subscriptionRecord.MatcherRule__c ) )
        {
            System.debug(LoggingLevel.DEBUG, 'match #4');
            answer = true;
        }

        else
        {
            System.debug(LoggingLevel.DEBUG, 'no match');
        }

        return answer;
    }

    private static Set<String> generateStringSetFromField(List<SObject> sobjList, SObjectField sobjField, Boolean includeBlankValues)
    {
        Set<String> result = new Set<String>();

        if (sobjList == null || sobjList.isEmpty()) return result;
        if (sobjField == null) return result;

        for (SObject sobj : sobjList)
        {
            String value = (String) sobj.get(sobjField);
            if (String.isNotBlank(value) || (String.isBlank(value) && includeBlankValues))
            {
                result.add(value);
            }
        }

        return result;
    }

    private static List<PlatformEvents_Subscription__mdt> getEventSubscribers(List<SObject> events)
    {
        // extract the event payloads
        Set<String> eventNameSet = generateStringSetFromField(events, LafEvent__e.EventName__c, false);
        Set<String> eventCategorySet = generateStringSetFromField(events, LafEvent__e.Category__c, false);

        System.debug(LoggingLevel.DEBUG, 'Platform_Event_Bus_Describe.getName(): ' + Platform_Event_Bus_Describe.getName());

        // need to read all available PlatformEvents_Subscription__mdt records for this event SObjectType
        // SOQL targeting custom MDT tables does not support the OR operator.  Manually filter.
        // https://help.salesforce.com/articleView?id=custommetadatatypes_limitations.htm
        List<PlatformEvents_Subscription__mdt> eventSubscriptionRecords = new List<PlatformEvents_Subscription__mdt>();
        for
        (
            PlatformEvents_Subscription__mdt ped :
            [
                select
                    Consumer__c, EventCategory__c, Event__c, IsActive__c, MatcherRule__c, EventBus__c, ExecuteSynchronous__c
                from PlatformEvents_Subscription__mdt
                where IsActive__c = true AND EventBus__c = :Platform_Event_Bus_Describe.getName()
            ]
        )
        {
            if (eventNameSet.contains(ped.Event__c) || eventCategorySet.contains(ped.EventCategory__c) || String.isBlank(ped.EventCategory__c))
            {
                eventSubscriptionRecords.add(ped);
            }
        }

        System.debug(
            LoggingLevel.DEBUG, 
            '\neventNameSet:\n\t' + eventNameSet + '\n' +
            'eventCategorySet:\n\t' + eventCategorySet + '\n' +
            'CMDT records:\n\t' + [select Consumer__c, EventCategory__c, Event__c, IsActive__c, MatcherRule__c, EventBus__c from PlatformEvents_Subscription__mdt] + '\n' +
            'Event bus name: ' + Platform_Event_Bus_Describe.getName() + '\n' +
            'eventSubscriptionRecords:\n\t' + eventSubscriptionRecords);

        return eventSubscriptionRecords;
    }
}
