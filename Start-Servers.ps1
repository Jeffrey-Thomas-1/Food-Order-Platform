# Foodie Orange Pro - Start Both Servers
# Usage: PowerShell -ExecutionPolicy Bypass -File Start-Servers.ps1

Write-Host "🚀 Starting Foodie Orange Pro..." -ForegroundColor Green
Write-Host "========================================`n"

# Get the script location
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Start Backend in new window
Write-Host "1️⃣  Starting Backend API (Port 5000)..." -ForegroundColor Cyan
$BackendPath = Join-Path $ScriptPath "Backend"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$BackendPath'; npm start" -WindowStyle Normal

# Wait a moment for backend to start
Start-Sleep -Seconds 3

# Start Frontend in new window
Write-Host "2️⃣  Starting Frontend Server (Port 8000)..." -ForegroundColor Cyan
$FrontendPath = Join-Path $ScriptPath "Frontend\public"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$FrontendPath'; python -m http.server 8000" -WindowStyle Normal

# Wait a moment
Start-Sleep -Seconds 2

# Open browser
Write-Host "3️⃣  Opening browser..." -ForegroundColor Cyan
Start-Sleep -Seconds 1
Start-Process "http://localhost:8000"

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "✅ Both servers started!" -ForegroundColor Green
Write-Host "Backend:  http://localhost:5000/api/health" -ForegroundColor Yellow
Write-Host "Frontend: http://localhost:8000" -ForegroundColor Yellow
Write-Host "========================================`n" -ForegroundColor Green
