# QuishesOS Docker Build Script for Windows
# Automatically builds the ISO using Docker

Write-Host "=== QuishesOS Docker ISO Builder ===" -ForegroundColor Green
Write-Host ""

# Check if Docker is running
Write-Host "Checking Docker..." -ForegroundColor Yellow
$dockerRunning = docker info 2>$null
if (-not $dockerRunning) {
    Write-Host "Error: Docker is not running!" -ForegroundColor Red
    Write-Host "Please start Docker Desktop and try again." -ForegroundColor Red
    exit 1
}
Write-Host "Docker is running!" -ForegroundColor Green
Write-Host ""

# Get script directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# Create output directory
$outDir = Join-Path $scriptPath "out"
if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir | Out-Null
    Write-Host "Created output directory: $outDir" -ForegroundColor Green
}

# Build Docker image
Write-Host "Building Docker image (this may take 5-10 minutes on first run)..." -ForegroundColor Yellow
docker build -t quishesos-builder .

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Docker image build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Docker image built successfully!" -ForegroundColor Green
Write-Host ""

# Run Docker container to build ISO
Write-Host "Building ISO (this may take 10-30 minutes)..." -ForegroundColor Yellow
Write-Host "Please wait..." -ForegroundColor Yellow
Write-Host ""

docker run --rm `
    --privileged `
    -v "${outDir}:/build/out" `
    quishesos-builder

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: ISO build failed!" -ForegroundColor Red
    Write-Host "Check the output above for errors." -ForegroundColor Red
    exit 1
}

# Check if ISO was created
$isoFiles = Get-ChildItem -Path $outDir -Filter "*.iso" -ErrorAction SilentlyContinue

if ($isoFiles.Count -eq 0) {
    Write-Host "Warning: No ISO file found in output directory" -ForegroundColor Yellow
    Write-Host "Build may have failed or ISO location incorrect" -ForegroundColor Yellow
    exit 1
}

# Success!
Write-Host ""
Write-Host "=== Build Successful! ===" -ForegroundColor Green
Write-Host ""

foreach ($iso in $isoFiles) {
    $isoSize = [math]::Round($iso.Length / 1MB, 2)
    Write-Host "ISO Created: $($iso.Name)" -ForegroundColor Green
    Write-Host "Location: $($iso.FullName)" -ForegroundColor Cyan
    Write-Host "Size: ${isoSize} MB" -ForegroundColor Cyan
    
    # Check for checksum
    $checksumFile = $iso.FullName + ".sha256"
    if (Test-Path $checksumFile) {
        Write-Host "Checksum: $checksumFile" -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "=== Next Steps ===" -ForegroundColor Yellow
Write-Host "1. Test in VM: Use VirtualBox or VMware" -ForegroundColor White
Write-Host "2. Write to USB:" -ForegroundColor White
Write-Host "   - Use Rufus (https://rufus.ie/)" -ForegroundColor White
Write-Host "   - Or Balena Etcher (https://www.balena.io/etcher/)" -ForegroundColor White
Write-Host "3. Boot from USB and test installation" -ForegroundColor White
Write-Host ""

# Open output folder
Write-Host "Opening output folder..." -ForegroundColor Green
Start-Process explorer.exe $outDir

Write-Host ""
Write-Host "Build complete!" -ForegroundColor Green
