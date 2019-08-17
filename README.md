# AuditScript
Audit Script to Save and Clear Event Logs

# Background

The PowerShell script auditLogPull.ps1 is meant to be solution for saving and clearing auditing logs on windows system 1803 + without having Splunk or other software installed. Later additions may allow this to work across domains as well.

It works by backing up the audit logs to a protected directory. The directory can be hardcoded as is currently. Later releases may include input to have dymanic folder creation.

From there it creates the folder of the currennt date when it backs up logs. The logs are backed up and cleared one by one. After the script is complete the logs can be viwed in the dated folder inside the chosen directory.

# Running the script manually

The script can be run manually, but there are a few steps that need to be taken before it can be run successfully. If the users are not part of an Admininstrative group on the systems the script is being run on, one that is will need to run in an admin cmd or ps window:

Set-ExecutionPolicy RemoteSigned

This will allow local execution of user created scripts. After that is successful, the script should run manually.

# Running via scheduled task

The script can also be run via scheduled task. This is a bit tricker, but can still be done. An account will need to be created along the lines of "Audit". This account will need to have Log on as a Batch permission at a minumum. It is recommended to add the "Audit" account to the Administrators group and assign the Deny Log on Locally permission to it.

Once those steps are complete, the task can be created. 

Give a name to the task as well as a description of what it will do. Make sure to select Logged in or not as well as run with highest privileges. Set for Win 10 compatibility. In the trigger section, set it for what is needed. 

Actions gets a little tricky:
Set Action to start a program
	Program Script: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
	Arguments: -NoLogo -File c:\pathToScript\auditLogPull.ps1 -ExecutionPolicy RemoteSigned
	Start In: C:\Windows\System32\WindowsPowerShell\v1.0
  
Conditions and Settings can stay standard unless changes are desired.
  
If you need to make any changes – make sure you use SYSTEMNAME\AccountName when setting the username and password for task updating and setting.
  
  





