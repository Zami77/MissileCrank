compilerPath='/Users/Dan/Developer/PlaydateSDK/bin/pdc'
# Shell script does not like spaces, so you'll have to rename PlaydateSimulator.app and PlaydateSimulator to be one word
simulatorPath='/Users/Dan/Developer/PlaydateSDK/bin/PlaydateSimulator.app/Contents/MacOS/PlaydateSimulator'
sourcePath='./source'
outputPath='./builds/MissleCrank.pdx'

# pdc [sourcepath] [outputpath]

echo "Compiler path:  $compilerPath"
echo "Simulator path: $simulatorPath"
echo "Source path:    $sourcePath"
echo "Output path:    $outputPath"
echo ""

[ ! -d "builds" ] && echo "Creating build directory..." && mkdir builds
echo "Cleaning build directory..."
rm -r builds/*

echo "Compile source..."
$compilerPath $sourcePath $outputPath

echo "Opening simulator..."
$simulatorPath $outputPath
