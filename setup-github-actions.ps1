Write-Host "=== QuishesOS GitHub Setup ===" -ForegroundColor Green
Write-Host ""

# Check git
$gitExists = Get-Command git -ErrorAction SilentlyContinue
if (!$gitExists) {
    Write-Host "ERROR: Git not installed" -ForegroundColor Red
    Write-Host "Download: https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}

# Init git if needed
$gitDir = Test-Path ".git"
if (!$gitDir) {
    Write-Host "Initializing git..." -ForegroundColor Yellow
    git init
    Write-Host "Done" -ForegroundColor Green
}

# Check remote
$hasRemote = $false
try {
    $remote = git remote get-url origin 2>&1
    if ($remote -and !$remote.ToString().Contains("error")) {
        $hasRemote = $true
        $repoUrl = $remote
    }
} catch {
    $hasRemote = $false
}

# Setup remote if needed
if (!$hasRemote) {
    Write-Host ""
    Write-Host "Setup GitHub repository:" -ForegroundColor Cyan
    Write-Host "1. Go to https://github.com/new"
    Write-Host "2. Create repository (e.g., QuishesOS)"
    Write-Host "3. Do NOT add README"
    Write-Host ""
    $repoUrl = Read-Host "Enter repository URL"
    git remote add origin $repoUrl
    Write-Host "Remote added" -ForegroundColor Green
}

# Stage and commit
Write-Host ""
Write-Host "Staging files..." -ForegroundColor Yellow
git add .
git commit -m "Initial QuishesOS commit"
Write-Host "Committed" -ForegroundColor Green

# Push
Write-Host ""
Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
git branch -M main
git push -u origin main

Write-Host ""
Write-Host "SUCCESS!" -ForegroundColor Green
Write-Host ""
Write-Host "Next: Go to https://github.com/YOUR_USERNAME/QuishesOS/actions"
Write-Host "Wait ~15-20 min for ISO build to complete"
Write-Host "Download ISO from Artifacts section"
Write-Host ""
