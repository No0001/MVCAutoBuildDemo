Using module ".\BuildWebPath.psm1"
#powerShell module

Function BuildWindowsService ([string]$csprojPath , [string] $debugPath , [string] $outputPath ,[string] $msbuild)
{
   
    if(Test-Path -Path $outputPath)
    {
        Write-Host "目錄已存在，進行刪除"
        Remove-Item $outputPath -Recurse
    }
    
    Write-Host "開始建立Windows Service"
    
    & $msbuild  $csprojpath -t:rebuild
    
    Copy-Item $debugPath -Destination $outputPath -Recurse

    if ($LastExitCode -ne 0)
    {
        $exitCode = $LastExitCode
    
        Write-Error "建立Windows Service 失敗"
    
        exit $exitCode
    }
    else
    {
        Write-Host "建立Windows Service 成功"
    
    }
}

function BuildWeb([BuildWebPath] $model) 
{
    
    if(Test-Path -Path $model.publishUrl)
    {
        Write-Host "目錄已存在，進行刪除"
        Remove-Item $model.publishUrl -Recurse
    }

    #nuget路徑
    $nuget = $PSScriptRoot + "\nuget.exe"

    #Git版本號
    #$version = $(git describe --abbrev=0 --tag)

    #還原套件
    Write-Host "還原套件----------"
     
    & $nuget restore $model.solutionFile

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

    & $model.msbuild $model.projectFile /p:DeployOnBuild=true /p:PublishProfile=FolderProfile.pubxml /p:PublishUrl=$model.publishUrl

    if($LastExitCode -ne 0)
    {
        $exitCode=$LastExitCode
        Write-Error "Publish failed!"
         #pause "執行結束"
        exit $exitCode
    }
    else
    {
        Write-Host "Publish succeeded"        
    }
}



