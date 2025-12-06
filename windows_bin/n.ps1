param (
    [string]$filename,
    [switch]$v
)

# Get the directory of the script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Choose template based on -v switch
$templateName = if ($v) { "template_v.cpp" } else { "template.cpp" }
$templateFile = Join-Path $scriptDir $templateName

# Define the target file path (in the current working directory)
$targetFile = Join-Path (Get-Location) "$filename.cpp"

# Check if the chosen template file exists
if (-Not (Test-Path $templateFile)) {
    Write-Host "Error: $templateName not found in $scriptDir" -ForegroundColor Red
    exit 1
}

# Check if the target file already exists
if (Test-Path $targetFile) {
    Write-Host "Error: The file '$filename.cpp' already exists in $(Get-Location)." -ForegroundColor Yellow
    exit 1
}

# Copy the template content to the new file in the current directory
Copy-Item -Path $templateFile -Destination $targetFile

Write-Host "File '$filename.cpp' created successfully using $templateName in $(Get-Location)!" -ForegroundColor Green