compilerPath='/Users/Dan/Developer/PlaydateSDK/bin/pdc'
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
