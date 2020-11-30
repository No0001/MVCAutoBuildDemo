#Build Web

Function pause ($message)
{
    # Check if running Powershell ISE
    if ($psISE)
    {
        Write-Host "==============Forms=================="
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.MessageBox]::Show("$message")
    }
    else
    {
        Write-Host "==============Yellow=================="
        Write-Host "$message" -ForegroundColor Yellow
        $x = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

function BuildWeb([string] $msbuild,[string] $solutionFile,[string] $projectFile,[string] $publishUrl) 
{
    Write-Host $msbuild
    Write-Host $solutionFile
    Write-Host $projectFile
    Write-Host $publishUrl

    Start-Transcript -Path "C:\output\$version\AP.log" -Append

    Remove-Item -Recurse -Force -ErrorAction Ignore "C:\output"

    #nuget路徑
    $nuget = $PSScriptRoot + "\nuget.exe"
    Write-Host   $nuget
    #Git版本號
    $version = $(git describe --abbrev=0 --tag)

    if ($LastExitCode -ne 0)
    {
        $exitCode=$LastExitCode
        Write-Error "取得版號失敗!"
        exit $exitCode
    }
    else
    {
        Write-Host "還原成功!"
    }

    #還原套件
    Write-Host "還原套件----------"
     
    & $nuget restore $solutionFile

    if ($LastExitCode -ne 0)
    {
        $exitCode=$LastExitCode
        Write-Error "還原失敗!"
        exit $exitCode
    }
    else
    {
        Write-Host "還原成功!"
    }

    Write-Host "Publish"

    & $msbuild $projectFile /p:DeployOnBuild=true /p:PublishProfile=FolderProfile.pubxml /p:PublishUrl=$publishUrl

    if($LastExitCode -ne 0)
    {
        $exitCode=$LastExitCode
        Write-Error "Publish failed!"
         pause "執行結束"
        exit $exitCode
    }
    else
    {
        Write-Host "Publish succeeded"        
    }

    Stop-Transcript


   
}

$msbuild = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\msbuild.exe"
$slnName = $PSScriptRoot + "\MVCAutoBuildDemo.sln";
$csprojName = $PSScriptRoot + "\Ptc.Dispatch.Web\MVCAutoBuildDemo.csproj";
$publishUrl = "C:\output\"




BuildWeb $msbuild $slnName $csprojName $publishUrl

