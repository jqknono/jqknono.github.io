Unregister-ScheduledTask -TaskName "T1" -Confirm:$false
$action = New-ScheduledTaskAction -Execute "D:\code_private\jqknono.github.io\test.exe"
$trigger1 = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 1) -Once -At 12am
$trigger2 = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "system"
$settings = New-ScheduledTaskSettingsSet
$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger1 $trigger2 -Settings $settings
Register-ScheduledTask -TaskName "T1" -TaskPath "jqknono" -InputObject $task 

Set-ScheduledTask -TaskName "T1" -TaskPath "jqknono" -Trigger $trigger1
