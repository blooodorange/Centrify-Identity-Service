## Reporting

### [ListRolesAndRefreshIdentity.ps1](https://github.com/blooodorange/Centrify-Identity-Service/blob/master/ListRolesAndRefreshIdentity.ps1)
* Gets a list of a user's roles and the administrative rights (using Centrify Identity Service REST API functions)
* Refreshes cache for a user (aka *Reload* in Cloud Manager)

[User management API reference](http://developer.centrify.com/site/global/documentation/api_reference/user_mgmt/index.gsp)

### [RunQuery.ps1](https://github.com/blooodorange/Centrify-Identity-Service/blob/master/RunQuery.ps1)
* Executes a SQL query (using Centrify Identity Service REST API functions)

Samples: [ReportingQueries.sql](https://github.com/blooodorange/Centrify-Identity-Service/blob/master/ReportingQueries.sql)

[Using queries](http://developer.centrify.com/site/global/documentation/api_guide/using_queries/index.gsp)

<br>
## Monitoring

### [CISCheckIWA.ps1](https://github.com/blooodorange/Centrify-Identity-Service/blob/master/CISCheckIWA.ps1)
* Sample script to check Cloud Connector's Integrated Windows Authentication functionality

<br>
## Application Integrations

### [SAML_DynamicsCRM.js](https://github.com/blooodorange/Centrify-Identity-Service/blob/master/SAML_DynamicsCRM.js)
* Custom SAML script to connect on-premises Microsoft Dynamics CRM (WS-Fed)

### [SAML_Office365.js](https://github.com/blooodorange/Centrify-Identity-Service/blob/master/SAML_Office365.js)
* Custom SAML script to connect Office 365 (SAML 2.0)

Enable SAML 2.0 passive authentication in Office 365: [Set-MsolDomainAuthentication_SAML.ps1](https://github.com/blooodorange/Centrify-Identity-Service/blob/master/Set-MsolDomainAuthentication_SAML.ps1)

### [SAML_AWS.js](https://github.com/blooodorange/Centrify-Identity-Service/blob/master/SAML_AWS.js)
* Custom SAML script to connect Amazon Web Services Console (SAML 2.0)
* AWS role mapping based on role membership in Centrify Identity Service

### [AuthPolicies.js](https://github.com/blooodorange/Centrify-Identity-Service/blob/master/AuthPolicies.js)
* Sample authentication policies
