# CISCheckIWA.ps1

$IWAUser = "" # domain account
$IWAPassword = "" | ConvertTo-SecureString -AsPlainText -Force
$CredsIWA = New-Object System.Management.Automation.PSCredential($IWAUser,$IWAPassword)

$Request = Invoke-WebRequest -Method Get -Uri "https://hostname:port/iwa/sitecheck" -Credential $CredsIWA

if($Request.StatusCode -eq "200" -and $Request.Content -match "success"){
    Write-Host "success" -ForegroundColor Green
    }
else{
    Write-Host "fail" -ForegroundColor Red
    }
    