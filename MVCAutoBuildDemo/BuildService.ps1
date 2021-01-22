Import-Module ".\msbuildmodule.psm1"

$msbuild = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\msbuild.exe"
$csprojpath = "C:\Project\SETOP\booking\Ptc.SETOP.Booking.WinService\Ptc.SETOP.Booking.WinService.csproj"
$debugPath = "C:\Project\SETOP\booking\Ptc.SETOP.Booking.WinService\bin\Debug\"
$outputPath = "C:\output\WS"




BuildWindowsService $csprojpath $debugPath $outputPath $msbuild
