# ListRolesAndRefreshIdentity.ps1
# Created by Blooodorange
# Version 1.0
# http://developer.centrify.com/site/global/documentation/api_reference/index.gsp
# https://github.com/centrify/centrify-samples-powershell
# https://cloud.centrify.com/vfslow/lib/api/dist/index.html

# Inputs

$Username = ""
$Password = ""
$Pod = "https://customer.my.centrify.com"

# Function GetAuthToken

Function GetAuthToken(){
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

# Function QueryReporting

Function QueryReporting(){
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

# Function GetUserAttributes

Function GetUserAttributes(){
    param(
        [Parameter(Mandatory=$true)]
        $Auth,
        [Parameter(Mandatory=$true)]
        $UUID,
        [Parameter(Mandatory=$true)]
        $Pod
    )
    $QueryHeaders = @{"X-CENTRIFY-NATIVE-CLIENT"="1";"Authorization" = "Bearer " + $Auth}
    $Query = Invoke-RestMethod -Method Post -Uri "$Pod/UserMgmt/GetUserAttributes" -ContentType "application/json" -Body "{""ID"":""$UUID""}" -Headers $QueryHeaders
    if($Query.Success -ne $true){
        throw "Error: $Query.Message"
    }
    return $Query.Result
}

# Function GetUserRolesAndRights

Function GetUserRolesAndRights(){
    param(
        [Parameter(Mandatory=$true)]
        $Auth,
        [Parameter(Mandatory=$true)]
        $UUID,
        [Parameter(Mandatory=$true)]
        $Pod
    )
    $QueryHeaders = @{"X-CENTRIFY-NATIVE-CLIENT"="1";"Authorization" = "Bearer " + $Auth}
    $Query = Invoke-RestMethod -Method Post -Uri "$Pod/UserMgmt/GetUsersRolesAndAdministrativeRights" -ContentType "application/json" -Body "{""ID"":""$UUID""}" -Headers $QueryHeaders
    if($Query.Success -ne $true){
        throw "Error: $Query.Message"
    }
    return $Query.Result
}

# Function RefreshIdentity

Function RefreshIdentity(){
    param(
        [Parameter(Mandatory=$true)]
        $Auth,
        [Parameter(Mandatory=$true)]
        $UUID,
        [Parameter(Mandatory=$true)]
        $Pod
    )
    $QueryHeaders = @{"X-CENTRIFY-NATIVE-CLIENT"="1";"Authorization" = "Bearer " + $Auth}
    $Query = Invoke-RestMethod -Method Post -Uri "$Pod/CDirectoryService/RefreshToken" -ContentType "application/json" -Body "{""ID"":""$UUID""}" -Headers $QueryHeaders
    if($Query.Success -ne $true){
        throw "Error: $Query.Message"
    }
    return $Query.Result
}

# Query roles and refresh identity

Write-Host "`n"

$SearchUsername = Read-Host "Please enter user's userPrincipalName"

$AuthToken = GetAuthToken -Username $Username -Password $Password -Pod $Pod

$ResultQueryReporting = QueryReporting -Auth $AuthToken -QueryJson "{""Script"":""select * from User where Username like '$SearchUsername' and SourceDsType = 'AdProxy'""}" -Pod $Pod
$UUID = $ResultQueryReporting.Results | Select-Object -ExpandProperty Row | select ID, Forest, Status, LastLogin
Write-Host "UUID: " -NoNewline
$UUID.ID
Write-Host "Status: " -NoNewline
$UUID.Status

$ResultGetAttributes = GetUserAttributes -Auth $AuthToken -Pod $Pod -UUID $UUID.ID
Write-Host "Display name: " -NoNewline
$ResultGetAttributes.displayname

RefreshIdentity -Auth $AuthToken -Pod $Pod -UUID $UUID.ID
Write-Host "Cached identity reloaded from directory service!" -ForegroundColor Green

$ResultGetRolesAndRights = GetUserRolesAndRights -Auth $AuthToken -Pod $Pod -UUID $UUID.ID
Write-Host "Current roles:"
$ResultGetRolesAndRights.Results | Select-Object -ExpandProperty Row | select Name, ID, Description | ft

Write-Host "`n"

# Cleanup variables

Clear-Variable -Name Result* -Force
Clear-Variable -Name UUID -Force
