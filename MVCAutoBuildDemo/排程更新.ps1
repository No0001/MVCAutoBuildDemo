#Requires -RunAsAdministrator
Function Set-ScheduledTask([string]$taskName, [string]$taskPath, [string]$ForceOverwrite = 'N' ,$action ,$trigger) {

  $chkExist = Get-ScheduledTask | Where-Object { $_.TaskName -eq $taskName  }
  if ($chkExist) {
      if ($ForceOverwrite -eq 'Y' -or $(Read-Host "[$taskName] 已存在，是否刪除? (Y/N)").ToUpper() -eq 'Y') {
          Unregister-ScheduledTask $taskName -Confirm:$false 
      }
      else {
          Write-Host "放棄新增作業" -ForegroundColor Red
          Exit 
      }
  }

  #本機 & 測試機
  Register-ScheduledTask $taskName -TaskPath $taskPath -Action $action -Trigger $trigger -User "SYSTEM" 
  #正式機
  #Register-ScheduledTask $taskName -TaskPath $taskPath -Action $action -Trigger $trigger -User "rdmbatch" -Password 'sBTK6Hgu'
}

$taskName = "OP-33 非會員轉贈掃描"
$taskPath = "\"
$ForceOverwrite = "N"
$action = New-ScheduledTaskAction -Execute "C:\Program Files\BatchCurl\Ptc.SETOP.BatchCurl.exe" -Argument '-u http://localhost/SETOPBatch/api/BackendBatchNoMemberTransfer/NoMemberTransferVoucher -r 5 -s 10 -l true -a true'
$trigger = New-ScheduledTaskTrigger -Once -At 0:01am -RepetitionInterval  (New-TimeSpan -Minutes 25)

Set-ScheduledTask $taskName $taskPath "N" $action $trigger

$taskName = "OP-34 情報上傳"
$taskPath = "\"
$ForceOverwrite = "N"
$action = New-ScheduledTaskAction -Execute "C:\Program Files\BatchCurl\Ptc.SETOP.BatchCurl.exe" -Argument '-u http://localhost/SETOPBatch/api/BackendBatchPresaleSystem/GetExportInformationPresaleData -r 5 -s 10 -l true -a true'
$trigger = New-ScheduledTaskTrigger -Daily  -At  2am

Set-ScheduledTask $taskName $taskPath "N" $action $trigger
