param(
    [Parameter(Mandatory=$true)]
    [string]$CppFile,          # Path to the C++ source file
    [string]$InputFile = ""    # Optional input file to pipe into the program
)

# Ensure clang++ is available
if (-Not (Get-Command clang++ -ErrorAction SilentlyContinue)) {
    Write-Host "Error: clang++ not found on PATH!" -ForegroundColor Red
    exit 1
}

# Append .cpp if the input file doesn't have an extension
if (-Not $CppFile.EndsWith(".cpp")) {
    $CppFile += ".cpp"
}

# Check if the input C++ file exists
if (-Not (Test-Path $CppFile)) {
    Write-Host "Error: C++ file '$CppFile' not found!" -ForegroundColor Red
    exit 1
}

# Default input file to "in" in the same directory as the C++ file if not provided
if ($InputFile -eq "") {
    $DefaultInputFile = "in"
    if (Test-Path $DefaultInputFile) {
        $InputFile = $DefaultInputFile
    }
}

# Define output file path
$OutputFile = "out"

# Generate the executable name (same name as source but with .exe extension)
$ExeFile = [System.IO.Path]::ChangeExtension($CppFile, ".exe")

### COMPILATION ###

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$pchDir = Join-Path $scriptDir "pch"
$pchFile = Join-Path $pchDir pch.h.pch

$CompileOptions = @("-Wall", "-Wextra", "-Wpedantic", "-Wshadow", "-std=c++17", "-O2", "-include-pch", $pchFile, "-I", $pchDir)
$StartTime = Get-Date
Write-Host "Compiling '$CppFile' with clang++..." -ForegroundColor Yellow
clang++ "$CppFile" $CompileOptions -o "$ExeFile"
$CompileTime = (Get-Date) - $StartTime

# Check if compilation was successful (exit code 0)
if ($LASTEXITCODE -ne 0) {
    Write-Host "Compilation failed! Exit code: $LASTEXITCODE" -ForegroundColor Red
    exit 1
}

Write-Host "Compilation successful: $ExeFile" -ForegroundColor Green
Write-Host ("Compilation time: {0:N2} seconds" -f $CompileTime.TotalSeconds) -ForegroundColor Magenta

### EXECUTION ###
$StartTime = Get-Date
Write-Host "Running '$ExeFile'..." -ForegroundColor Cyan

if ($InputFile -ne "" -and (Test-Path $InputFile)) {
    Write-Host "Using input from '$InputFile' and saving output to '$OutputFile'." -ForegroundColor Cyan
    Get-Content $InputFile | & ./$ExeFile | Tee-Object -FilePath $OutputFile
} else {
    Write-Host "Running interactively and saving output to '$OutputFile'." -ForegroundColor Cyan
    & ./$ExeFile | Tee-Object -FilePath $OutputFile
}

$RunTime = (Get-Date) - $StartTime
Write-Host ("Execution time: {0:N2} seconds" -f $RunTime.TotalSeconds) -ForegroundColor Magenta

Write-Host "Execution complete. Output saved to '$OutputFile'." -ForegroundColor Green