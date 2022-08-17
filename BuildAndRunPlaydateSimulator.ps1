param (
    [string]$buildDir = ".\builds",
    [string]$sourceDir = ".\sourceDir",
    [string]$gameName = (Get-Item -Path .).BaseName
)
$pdx = Join-Path -Path "$buildDir" -ChildPath "$gameName.pdx"

New-Item -ItemType Directory -Force -Path "$buildDir"

# Clean buildDir
Remove-Item "$buildDir\*" -Recurse -Force 

# Build project
Write-Output "$Env:PLAYDATE_SDK_PATH"
    pdc -sdkpath "$Env:PLAYDATE_SDK_PATH" "$sourceDir" "$pdx"

# Run simulator
& "$Env:PLAYDATE_SDK_PATH\bin\PlaydateSimulator.exe" "$pdx"