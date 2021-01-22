Using module ".\BuildWebPath.psm1"

Import-Module -Force ".\msbuildmodule.psm1"

$msbuild = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\msbuild.exe"
$basePath = "C:\Project\Myproject"
$projectName = "MVCAutoBuildDemo"
$publishUrl = "C:\output\AP"

$dev = [BuildWebPath]::new($msbuild,$basePath,$projectName,$publishUrl)

BuildWeb $dev


