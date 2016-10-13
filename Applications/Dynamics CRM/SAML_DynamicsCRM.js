/* Code - Start */

/* myServiceUrl contains ACS Endpoint 
** from CRM Claims-Based Authentication
** Please avoid trailing slash in the Service URL
*/
var myServiceUrl = ServiceUrl;

/* Specify external URL */
var externalUrl = "https://crmauth.domain.com";

var wtrealm = Request["wtrealm"];

/* For IFD - Start */
if(wtrealm != null) {
  	/* For SP - Start */
  	if (wtrealm.indexOf(ServiceUrl) == -1) { /* If accessed with IFD enabled */
  		myServiceUrl = externalUrl;
	}
  	/* For SP - End */
} else {
  	/* For IdP - Start */
  	var orgname = Request["org"];
  	if(orgname != null) {
	  	/* Replacing Organization Name with host name */
		var ServiceUrlSplitArr = ServiceUrl.split("/");
		var hostUrlSplitArr = ServiceUrlSplitArr[2].split(".");
		hostUrlSplitArr[0] = orgname;
		ServiceUrlSplitArr[2] = hostUrlSplitArr.join(".");
		myServiceUrl = externalUrl;
	  	setWctx("ru="+ServiceUrlSplitArr.join("/")+"%2fdefault.aspx");
  	} else {
		setWctx("ru=%2fdefault.aspx");
  	}
	/* For IdP - End */
}
/* Code - End */

setAudience(myServiceUrl);
setRecipient(myServiceUrl);
setServiceUrl(myServiceUrl);
setHttpDestination(myServiceUrl);

setVersion('1');
setIssuer(Issuer);
setSubjectName(LoginUser.Username);
setAuthenticationMethod('urn:federation:authentication:windows');
setSignatureType('Assertion');

/* Required claims */
setCustomAttribute('name', 'http://schemas.xmlsoap.org/ws/2005/05/identity/claims', LoginUser.DisplayName);
setCustomAttribute('upn', 'http://schemas.xmlsoap.org/ws/2005/05/identity/claims', LoginUser.Username);
addSubjectToAttrStatement("True");
