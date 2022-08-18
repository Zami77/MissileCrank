compilerPath='/Users/Dan/Developer/PlaydateSDK/bin/pdc'
simulatorPath='/Users/Dan/Developer/PlaydateSDK/bin/PlaydateSimulator'
sourcePath='./source'
outputPath='./build/MissleCrank.pdx'

# pdc [sourcepath] [outputpath]

echo "Compiler path:  $compilerPath"
echo "Simulator path: $simulatorPath"
echo "Source path:    $sourcePath"
echo "Output path:    $outputPath"
echo ""

[ ! -d "build" ] && echo "Creating build directory..." && mkdir build
echo "Cleaning build directory..."
rm -r build/*

echo "Compile source..."
$compilerPath $sourcePath $outputPath

echo "Opening simulator..."
$simulatorPath $outputPath
