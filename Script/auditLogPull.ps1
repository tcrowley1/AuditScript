<#
Script to get audit logs backed up and saved to a proteted directory
Works by backing up each log and saves it to a directory. Right now this works on standalone win 10 -- tested on 1903

T.Crowley 8-16-19
#>

#Allow personal scripts to be run on the system if it is not enabled. Copy below and copy without #, into an admin cmd or ps window.
#Set-ExecutionPolicy RemoteSigned

#Makes a folder for the date of the pull
$LogDate = Get-Date -Format yyyy-MM-dd

#Change the mkdir line below with your path required
mkdir C:\pathToFolder\$LogDate

#Set a patch for backup -- this should default to C:\pathToFolder\DATE
$Path = "C:\pathToFolder\$LogDate"

<#
Backup the Security,System and Application logs 
The logs will be backed up and cleared in order
Security first, then System, then Application
#>

#Var for the Security event log
$EventLog = Get-WmiObject Win32_NTEventlogFile -Filter "LogFileName = 'Security'"

#New event log pull and append
$EventLog.BackupEventlog("$Path\$env:COMPUTERNAME`_Security.evtx")

#After backup , clear the logs for the next pull
Clear-EventLog -LogName Security


#Var for the System event log
$EventLog = Get-WmiObject Win32_NTEventlogFile -Filter "LogFileName = 'System'"

#New event log pull and append
$EventLog.BackupEventlog("$Path\$env:COMPUTERNAME`_System.evtx")

#After backup , clear the logs for the next pull
Clear-EventLog -LogName System

#Var for the Application event log
$EventLog = Get-WmiObject Win32_NTEventlogFile -Filter "LogFileName = 'Application'"

#New event log pull and append
$EventLog.BackupEventlog("$Path\$env:COMPUTERNAME`_Application.evtx")

#After backup , clear the log
Clear-EventLog -LogName Application