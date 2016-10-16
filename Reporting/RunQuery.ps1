# RunQuery.ps1
# Created by Blooodorange
# Version 1.0

$Username = ""
$Password = ""
$Pod = "https://customer.my.centrify.com"
$Query = "SELECT EventType, WhenOccurred, NormalizedUser, UserName, AuthMethod, Factors, FromIPAddress, RequestDeviceOS FROM event WHERE EventType = 'Cloud.Core.Login' AND WhenOccurred BETWEEN dateFunc('2016-08-26 11:00') AND dateFunc('2016-08-27 11:00')"

# Function Login
Function Login(){
    param(
        [Parameter(Mandatory=$true)]
        $Username,
        [Parameter(Mandatory=$true)]
        $Password,
        [Parameter(Mandatory=$true)]
        $Pod
    )
    $LoginJson = "{user:'$Username', password:'$Password'}"
    $Login = Invoke-WebRequest -Method Post -Uri "$Pod/security/login" -ContentType "application/json" -Body $LoginJson -SessionVariable WebSession -UseBasicParsing
    $Cookies = $WebSession.Cookies.GetCookies("$Pod/security/login")
    $ASPXAuth = $Cookies[".ASPXAUTH"].Value
    return $ASPXAuth
}

# Function Query
Function Query(){
    param(
        [Parameter(Mandatory=$true)]
        $Auth,
        [Parameter(Mandatory=$true)]
        $QueryJson,
        [Parameter(Mandatory=$true)]
        $Pod
    )
    $QueryHeaders = @{"X-CENTRIFY-NATIVE-CLIENT"="1";"Authorization" = "Bearer " + $Auth}
    $Query = Invoke-RestMethod -Method Post -Uri "$Pod/RedRock/query" -ContentType "application/json" -Body $QueryJson -Headers $QueryHeaders
    if($Query.Success -ne $true){
        throw "Error: $Query.Message"
    }
    return $Query.Result
}

# Login to API
$AuthToken = Login -Username $Username -Password $Password -Pod $Pod

# Query and Out-GridView results
$Result = Query -Auth $AuthToken -QueryJson "{""Script"":""$Query""}" -Pod $Pod
$Result.Results | Select-Object -ExpandProperty Row | Select WhenOccurred, EventType, NormalizedUser, UserName, AuthMethod, Factors, FromIPAddress, RequestDeviceOS | Out-GridView

# Cleanup variables
Clear-Variable -Name Query* -Force
Clear-Variable -Name Result* -Force
