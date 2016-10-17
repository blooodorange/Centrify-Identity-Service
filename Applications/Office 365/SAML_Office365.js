// Office 365 - Custom SAML 2.0 script for Centrify's generic app template

function guidToBase64(guidString, littleEndian) { var hexlist = '0123456789abcdef'; var b64list = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

var hexString = guidString.replace(/[^0-9a-f]/ig, '').toLowerCase();

if (littleEndian) {
hexString = hexString.slice(6, 8) + hexString.slice(4, 6) + hexString.slice(2, 4) + hexString.slice(0, 2) + hexString.slice(10, 12) + hexString.slice(8, 10) + hexString.slice(14, 16) + hexString.slice(12, 14) + hexString.slice(16); } hexString += '0';

var a, p, q;
var result = '';
for(var i = 0; i<33;) {
a = (hexlist.indexOf(hexString.charAt(i++)) << 8) |
(hexlist.indexOf(hexString.charAt(i++)) << 4) | (hexlist.indexOf(hexString.charAt(i++)));

p = a >> 6;
q = a & 63;

result += b64list.charAt(p) + b64list.charAt(q); } result += '==';

return result;
}

var GUID = LoginUser.Get('ObjectGUID');
var ImmutableID = guidToBase64(GUID, true);
setIssuer(Issuer);
setSubjectName(ImmutableID);
setAudience('urn:federation:MicrosoftOnline');
setRecipient(ServiceUrl);
setHttpDestination(ServiceUrl);
setSignatureType('Assertion');
setNameFormat('urn:oasis:names:tc:SAML:2.0:nameid-format:persistent');
setVersion('2');
setAttribute('IDPEmail', LoginUser.Username);
