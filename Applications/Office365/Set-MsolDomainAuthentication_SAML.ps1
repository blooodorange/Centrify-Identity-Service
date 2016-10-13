# https://msdn.microsoft.com/en-us/library/azure/dn641269.aspx
# https://technet.microsoft.com/library/dn194112.aspx
# https://developer.salesforce.com/page/Configuring-SAML-SSO-to-Office365
# https://ping.force.com/Support/Office-365-Switching-the-federation-protocol-to-SAML-from-WS-Federation

$Domain = "domain.com"
$Brand = "Centrify-Identity-Service"
$IdPSignInURL = ""
$Issuer = ""
$IdPLogOutURL = ""
$SigningCertificate = ""

Connect-MsolService
Set-MsolDomainAuthentication –DomainName $Domain -FederationBrandName $Brand -Authentication Federated -PassiveLogOnUri $IdPSignInURL -SigningCertificate $SigningCertificate -IssuerUri $Issuer -LogOffUri $IdPLogOutURL -PreferredAuthenticationProtocol SAMLP
