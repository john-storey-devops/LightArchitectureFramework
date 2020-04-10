# Interim Architecture Framework

In lieu of the adoption of more extensive and commonly prescribed architectural frameworks, this interim framework provides some basic functionality that facilitates more precise and limited unit testing, while minimizing the technical debt when successive frameworks are adopted.


## Basic Design Principle

The [FFLIB Mocks](https://github.com/apex-enterprise-patterns/fflib-apex-mocks) and [Common](https://github.com/apex-enterprise-patterns/fflib-apex-common) frameworks are the model for this design, along with some Custom Metadata configuration extensions inspired by [AT4DX](https://github.com/ImJohnMDaniel/at4dx).

Review the many attributions linked in those repos for deeper insight to that listed in this document.


## Deployment

Only the resources in the `force-app/main/default` folder are required.  As named, the `.../sample` folder is for edification or insight only.


## Selector Pattern

The general purpose for the selector pattern is to encapsulate SOQL functionality in a central, reusable location.

### Adding a New Selector

1. Create the selector's interface which extends the `ISObjectSelector` and includes the selection methods needed.  Refer to the `IAccountSelector` in the sample implementations.
2. Create the selector's class modeling after the `AccountSelector`.
3. Create a `ApplicationSelectorBinding` record.
4. Provide quality unit tests.


### Adding a New Method to an Existing Selector

1. Add the new method to the selector's interface.
2. Add the new method to the selector.
3. Add quality unit testing.


## Domain Pattern

The general purpose for the Domain pattern is to centralize logic that is not suitable for declarative techniques into a central, reusable location.

### Adding a New Domain

1. Create the domain's interface which extends `IDomain` and includes the business-logic methods needed.  Refer to the `AccountDomain` in the sample implementations.
2. Create the domain class modeling after the `AccountDomain`.
3. Create a `ApplicationDomainBinding` record.
4. Provide quality unit tests.

### Adding a New Method to an Existing Domain

1. Add the new method to the domain's interface.
2. Add the new method to the domain.
3. Add quality unit testing.


## Further Question, Comments or Information

PLEASE! ... feel free to contact any of the Technical Architects or Lead Developers to report problems or seek further information.