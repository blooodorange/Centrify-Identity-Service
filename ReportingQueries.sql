/*
ReportingQueries.sql
http://developer.centrify.com/site/global/documentation/api_guide/data_dictionary/index.gsp
*/

-- Count: Total users on tenant
SELECT count(*) AS Count FROM User

-- Display all roles on tenant
SELECT ID, Name, Description FROM Role

-- Successful logins (BETWEEN time + specific user)
SELECT WhenOccurred, NormalizedUser, UserName, AuthMethod, Factors, FromIPAddress, RequestDeviceOS FROM Event
WHERE EventType = 'Cloud.Core.Login'
AND WhenOccurred BETWEEN dateFunc('2016-08-26 11:00') AND dateFunc('2016-08-27 11:00')
AND NormalizedUser = "User1@domain.com"
ORDER BY WhenOccurred DESC

-- Successful logins (BETWEEN time + specific user)
SELECT WhenOccurred, NormalizedUser, UserName, AuthMethod, Factors, FromIPAddress, RequestDeviceOS FROM event
WHERE EventType = 'Cloud.Core.Login.ServiceLogin'   -- WS-Federation Active Requestor Profile
AND WhenOccurred BETWEEN dateFunc('2016-08-26 11:00') AND dateFunc('2016-08-27 11:00')
AND NormalizedUser = "User1@domain.com"
ORDER BY WhenOccurred DESC

-- Count: Successful logins per operating system (last X days)
SELECT CASE(RequestDeviceOS)
WHEN 'Windows' THEN 'Access via Microsoft Windows'
WHEN 'iOS' THEN 'Access via iOS'
WHEN 'Android' THEN 'Access via Android'
WHEN 'Mac' THEN 'Access via Mac OS'
WHEN 'Unknown' THEN 'Non-browser access - e.g. access via API'
END AS 'RequestDeviceOS', count(*) AS Count FROM Event
WHERE EventType = 'Cloud.Core.Login'
AND WhenOccurred >= DateFunc('now','-X')
GROUP BY RequestDeviceOS
ORDER BY Count DESC

-- Count: Successful logins per country (last X days)
SELECT IPLookup(FromIPAddress,'country_name') AS Country, count(*) AS Count FROM Event
WHERE EventType = 'Cloud.Core.Login'
AND WhenOccurred >= DateFunc('now','-X')
GROUP BY Country
ORDER BY Count DESC

-- Failed login attempts (BETWEEN time)
SELECT WhenOccurred, NormalizedUser, FailUserName, AuthMethod, Factors, FromIPAddress, RequestDeviceOS, FailReason FROM Event
WHERE EventType = 'Cloud.Core.LoginFail'
AND WhenOccurred BETWEEN dateFunc('2016-08-26 11:00') AND dateFunc('2016-08-27 11:00')
ORDER BY WhenOccurred DESC

-- Count: Application logins (specific app - last X days)
SELECT ID AS _ID, ApplicationName AS Name, count(*) AS Count FROM Event
WHERE WhenOccurred >= DateFunc('now', '-X')
AND EventType='Cloud.Saas.Application.AppLaunch'
AND applicationname='AppName'

-- Count: Application logins (all apps - last X days)
SELECT ID AS _ID, ApplicationName AS Name, count(*) AS Count FROM Event
WHERE WhenOccurred >= DateFunc('now', '-X')
AND EventType='Cloud.Saas.Application.AppLaunch'
GROUP BY Name
ORDER BY Count DESC

-- Current time
SELECT time('now')

-- Current date and time
SELECT datetime('now')
