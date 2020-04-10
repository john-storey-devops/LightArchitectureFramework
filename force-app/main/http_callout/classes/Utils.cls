public without sharing class Utils
{
    public class UtilsException extends Exception { }
    public class UtilsArgumentException extends Exception { }

    public static final Organization org;

    static
    {
        org = [select Id, Name, Division, GeocodeAccuracy
                    , Phone, Fax, PrimaryContact, DefaultLocaleSidKey, LanguageLocaleKey
                    , ReceivesInfoEmails, ReceivesAdminInfoEmails, PreferencesRequireOpportunityProducts
                    , FiscalYearStartMonth, UsesStartDateAsFiscalYearName, DefaultAccountAccess
                    , DefaultContactAccess, DefaultOpportunityAccess, DefaultLeadAccess, DefaultCaseAccess
                    , DefaultCalendarAccess, DefaultPricebookAccess, DefaultCampaignAccess, ComplianceBccEmail
                    , UiSkin, SignupCountryIsoCode, TrialExpirationDate, OrganizationType, NamespacePrefix
                    , InstanceName, IsSandbox, WebToCaseDefaultOrigin, MonthlyPageViewsUsed, MonthlyPageViewsEntitlement
                    , IsReadOnly, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById
                 from Organization
                limit 1];
    }

    @TestVisible
    private Utils() {}
}