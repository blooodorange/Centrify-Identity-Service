/*
This script allowes external access for users in specific roles.
Replace <role_name_1> etc. with the actual role names.
*/

policy.RequiredLevel = 2;

if(!context.onPrem){
    trace("not onprem");
      
    var umod = module('User');
    var user = umod.GetCurrentUser();
    var allowed_roles = ["<role_name_1>", "<role_name_2>"];
    
    if(user.InRoleByNames(allowed_roles)){
        trace("allow specified role");
        policy.RequiredLevel = 1;
    }
}     

/*
This script enforces MFA for users outside the corporate network.
*/

if(!context.onPrem){
    trace("not onprem");
	policy.RequiredLevel = 2;
}
else{
	trace("on prem");
	policy.RequiredLevel = 1;
}
