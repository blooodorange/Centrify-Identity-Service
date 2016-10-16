/* Amazon Web Services - Custom SAML 2.0 script for Centrify's generic app template  */

setVersion('2');
setIssuer(Issuer);
setSubjectName(LoginUser.Username);
setAudience('urn:amazon:webservices');
setRecipient(ServiceUrl);
setSignatureType('Assertion');
setServiceUrl(ServiceUrl);
setHttpDestination(ServiceUrl);
setNameFormat('persistent');

/* Attribute: RoleSessionName */
setAttribute('https://aws.amazon.com/SAML/Attributes/RoleSessionName', LoginUser.Username);

/* Attribute: Role
** http://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html
*/
var roleNames = LoginUser.RoleNames;
var attrArray = new Array();
for (var i=0; i < roleNames.Length; i++){
switch (roleNames[i]){
    case 'Centrify_Role1':
        AWSRole = 'arn:aws:iam::account-id:role/role-name,arn:aws:iam::account-id:saml-provider/provider-name';
		attrArray.push(AWSRole);
        break;
    case 'Centriy_Role2':
        AWSRole = 'arn:aws:iam::account-id:role/role-name,arn:aws:iam::account-id:saml-provider/provider-name';
		attrArray.push(AWSRole);
        break;
	}
}
setAttributeArray('https://aws.amazon.com/SAML/Attributes/Role', attrArray);

/* set SessionDuration to 8 hours
** https://blogs.aws.amazon.com/security/post/Tx3GL3IZE3FIGB6/Enable-Your-Federated-Users-to-Work-in-the-AWS-Management-Console-for-up-to-12-hours
*/
setCustomAttribute('https://aws.amazon.com/SAML/Attributes/SessionDuration', 'SessionDuration', '28800');
