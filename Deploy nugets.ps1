$deployPROD = $false

function Deploy-Project($project, $apiKey) {
	if ($deployPROD) {
		$files = Get-ChildItem $project\bin\release\*.nupkg
		foreach ($f in $files) {
			$outputFile = Split-Path $f -leaf
			dotnet nuget push --source "byronGit" --api-key $apiKey --skip-duplicate $f
		}
	} else {
		$files = Get-ChildItem $project\bin\debug\*.nupkg
		$targetDir = "\\byronfiles2\BIS\byronONE_DEV"
		foreach ($f in $files) {
			$outputFile = Split-Path $f -leaf
			$target = $targetDir + "\" + $outputFile
			if (Test-Path $target) {
				Write-Host "$outputFile ignored"
			} else {
				Copy-Item $f $target
				Write-Host "$outputFile copied" -ForegroundColor Yellow
			}
		}
	}
}

Write-Host "Deploy PROD (y/n) [n] " -ForegroundColor Yellow -NoNewline
$deployWhat = Read-Host
if ($deployWhat -ne "") {
	$deployPROD  = ($deployWhat -eq "y") -or ($deployWhat -eq "Y")
}

if ($deployPROD) {
	Write-Host "Personal GitHub Access Token (aka Api-Key) " -ForegroundColor Yellow -NoNewline
	$apiKey = Read-Host
} else {
	$apiKey = ""
}

Deploy-Project ".\Xbim.Geometry" $apiKey
Deploy-Project ".\Xbim.Geometry.Engine.Interop" $apiKey
Deploy-Project ".\Xbim.ModelGeometry.Scene" $apiKey

Write-Host "fertig - bitte Taste drücken..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
