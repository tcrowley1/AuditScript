<#
Script to get audit logs backed up and saved to a proteted directory
Works by backing up each log and saves it to a directory. Right now this works on standalone win 10 -- tested on 1903

T.Crowley 8-16-19
#>

#Allow personal scripts to be run on the system if it is not enabled. Copy below and copy without #, into an admin cmd or ps window.
#Set-ExecutionPolicy RemoteSigned


#Makes a folder for the date of the pull
$LogDate = Get-Date -Format yyyy.MM.dd

#Change the mkdir line below with your path required
mkdir C:\Audit\Windows\Logs\$LogDate


#Set a patch for backup -- this should default to C:\pathToFolder\DATE
$Path = "C:\Audit\Windows\Logs\$LogDate"


#Set a var for the System Name . which is appended to the Log names
$systemName = $env:COMPUTERNAME | Select-Object

<#
Backup the Security,System and Application logs 
The logs will be backed up and cleared in order
Security first, then System, then Application
#>

#Var for the Security event log
$EventLog = Get-WmiObject Win32_NTEventlogFile -Filter "LogFileName = 'Security'"

#New event log pull and append
$EventLog.BackupEventlog("$Path\$systemName`_Security.evtx")

#After backup , clear the logs for the next pull
Clear-EventLog -LogName Security


#Var for the System event log
$EventLog = Get-WmiObject Win32_NTEventlogFile -Filter "LogFileName = 'System'"

#New event log pull and append
$EventLog.BackupEventlog("$Path\$systemName`_System.evtx")

#After backup , clear the logs for the next pull
Clear-EventLog -LogName System

#Var for the Application event log
$EventLog = Get-WmiObject Win32_NTEventlogFile -Filter "LogFileName = 'Application'"

#New event log pull and append
$EventLog.BackupEventlog("$Path\$systemName`_Application.evtx")

#After backup , clear the log
Clear-EventLog -LogName Application

#Create the HTML reports

#Create a report with the current date and set the output to that path
mkdir C:\Audit\Windows\Reports\$LogDate
$RepPath = "C:\Audit\Windows\Reports\$LogDate"


#Set vars for the backed up log names
$LogName1 = "$systemName`_System.evtx"
$LogName2 = "$systemName`_Security.evtx"
$LogName3 = "$systemName`_Application.evtx"

#Ugly looking html page that shows event logs

Get-WinEvent -Path "$Path\$LogName1" | ConvertTo-Html >> $RepPath\System_Log.html
Get-WinEvent -Path "$Path\$LogName2" | ConvertTo-Html >> $RepPath\Security_Log.html
Get-WinEvent -Path "$Path\$LogName3" | ConvertTo-Html >> $RepPath\Application_Log.html

