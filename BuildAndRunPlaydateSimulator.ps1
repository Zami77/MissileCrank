param (
    [string]$buildDir = ".\builds",
    [string]$sourceDir = ".\source",
    [string]$gameName = (Get-Item -Path .).BaseName
)
$pdx = Join-Path -Path "$buildDir" -ChildPath "$gameName.pdx"

New-Item -ItemType Directory -Force -Path "$buildDir"

# Clean buildDir
Remove-Item "$buildDir\*" -Recurse -Force 

# Build project
Write-Output "$Env:PLAYDATE_SDK_PATH"
    pdc -sdkpath "$Env:PLAYDATE_SDK_PATH" "$sourceDir" "$pdx"

    # Close Simulator
$sim = Get-Process "PlaydateSimulator" -ErrorAction SilentlyContinue

if ($sim)
{
    $sim.CloseMainWindow()
    $count = 0
    while (!$sim.HasExited) 
    {
        Start-Sleep -Milliseconds 10
        $count += 1

        if ($count -ge 5)
        {
            $sim | Stop-Process -Force
        }
    }
}

# Run simulator
& "$Env:PLAYDATE_SDK_PATH\bin\PlaydateSimulator.exe" "$pdx"