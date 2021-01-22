class BuildWebPath
{
   BuildWebPath(
     [string] $msbuild = $( throw "Missing required parameter msbuild"),
     [string] $basePath = $( throw "Missing required parameter basePath"),
     [string] $projectName = $( throw "Missing required parameter projectName"),
     [string] $publishUrl = $( throw "Missing required parameter publishUrl")
   )
   {
        $slnName = $projectName + ".sln"
        $csprojName = $projectName + ".csproj"
        $this.msbuild = $msbuild
        $this.publishUrl = $publishUrl
        $this.solutionFile = (get-childItem $basePath -recurs –Include $slnName).ToString();
        $this.projectFile = (get-childItem $basePath -recurs –Include $csprojName).ToString();
   }

   [string] $msbuild
   [string] $solutionFile
   [string] $projectFile
   [string] $publishUrl
}