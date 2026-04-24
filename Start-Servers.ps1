# Foodie Orange Pro - Start Both Servers
# Usage: PowerShell -ExecutionPolicy Bypass -File Start-Servers.ps1 [start|stop]

param(
	[string]$Mode = "start"
)

if ($Mode -ieq "stop") {
	Write-Host "🛑 Stopping Foodie Orange servers..." -ForegroundColor Yellow
	$ports = @(5000, 8000)
	$connections = Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue |
		Where-Object { $ports -contains $_.LocalPort } |
		Select-Object -ExpandProperty OwningProcess -Unique

	if (-not $connections) {
		Write-Host "No running server processes found on ports 5000/8000." -ForegroundColor DarkYellow
		return
	}

	foreach ($pid in $connections) {
		Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
	}

	Write-Host "✅ Servers stopped on ports 5000/8000." -ForegroundColor Green
	return
}

Write-Host "🚀 Starting Foodie Orange Pro..." -ForegroundColor Green
Write-Host "========================================`n"

Write-Host "0️⃣  Clearing existing listeners (5000/8000)..." -ForegroundColor DarkCyan
$ports = @(5000, 8000)
$connections = Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue |
	Where-Object { $ports -contains $_.LocalPort } |
	Select-Object -ExpandProperty OwningProcess -Unique

if ($connections) {
	foreach ($pid in $connections) {
		Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
	}
	Write-Host "Stopped existing processes on ports 5000/8000." -ForegroundColor DarkYellow
} else {
	Write-Host "No existing listeners found on ports 5000/8000." -ForegroundColor DarkYellow
}

# Get the script location
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Start Backend in new window
Write-Host "1️⃣  Starting Backend API (Port 5000)..." -ForegroundColor Cyan
$BackendPath = Join-Path $ScriptPath "Backend"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$BackendPath'; node server.js" -WindowStyle Normal

# Wait a moment for backend to start
Start-Sleep -Seconds 3

# Start Frontend in new window
Write-Host "2️⃣  Starting Frontend Server (Port 8000)..." -ForegroundColor Cyan
$FrontendPath = Join-Path $ScriptPath "Frontend"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$FrontendPath'; python -m http.server 8000" -WindowStyle Normal

# Wait a moment
Start-Sleep -Seconds 2

# Open browser
Write-Host "3️⃣  Opening browser..." -ForegroundColor Cyan
Start-Sleep -Seconds 1
Start-Process "http://localhost:8000/public/index.html"

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "✅ Both servers started!" -ForegroundColor Green
Write-Host "Backend:  http://localhost:5000/api/health" -ForegroundColor Yellow
Write-Host "Frontend: http://localhost:8000/public/index.html" -ForegroundColor Yellow
Write-Host "========================================`n" -ForegroundColor Green
