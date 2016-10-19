# CISCheckIWA.ps1
# Script to check Cloud Connector's Integrated Windows Authentication functionality

$IWAUser = ""
$IWAPassword = "" | ConvertTo-SecureString -AsPlainText -Force
$CredsIWA = New-Object System.Management.Automation.PSCredential($IWAUser,$IWAPassword)

$Res = Invoke-WebRequest -Method Get -Uri "https://hostname:port/iwa/sitecheck" -Credential $CredsIWA

if($Res.StatusCode -eq "200" -and $Res.Content -match "success"){
    Write-Host "success" -ForegroundColor Green
    }
else{
    Write-Host "fail" -ForegroundColor Red
    }
    