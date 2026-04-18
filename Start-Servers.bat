@echo off
REM Foodie Orange Pro - Start Both Servers
REM Simply double-click this file to start everything

if /I "%~1"=="stop" goto stop

color 0A
echo.
echo ==========================================
echo   FOODIE ORANGE PRO - SERVER LAUNCHER
echo ==========================================
echo.

echo [0/3] Clearing existing listeners on ports 5000 and 8000...
for /f %%r in ('powershell -NoProfile -Command "$ports=@(5000,8000); $pids=Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue ^| Where-Object { $ports -contains $_.LocalPort } ^| Select-Object -ExpandProperty OwningProcess -Unique; if($pids){$pids ^| ForEach-Object { Stop-Process -Id $_ -Force -ErrorAction SilentlyContinue }; Write-Output 'STOPPED'} else {Write-Output 'NONE'}"') do set PRESTOP_RESULT=%%r

if /I "%PRESTOP_RESULT%"=="STOPPED" (
	echo Existing processes stopped.
) else (
	echo No existing listeners found.
)

REM Start Backend
echo [1/3] Starting Backend API on Port 5000...
start "Foodie Orange - Backend" cmd /k "cd /d "%CD%\Backend" && node server.js"

REM Wait for backend to initialize
timeout /t 3 /nobreak

REM Start Frontend
echo [2/3] Starting Frontend Server on Port 8000...
start "Foodie Orange - Frontend" cmd /k "cd /d "%CD%\Frontend" && python -m http.server 8000"

REM Wait a moment
timeout /t 2 /nobreak

REM Open browser
echo [3/3] Opening browser...
timeout /t 1 /nobreak
start http://localhost:8000/public/index.html

echo.
echo ==========================================
echo   ✅ Servers Started Successfully!
echo ==========================================
echo.
echo Backend:  http://localhost:5000/api/health
echo Frontend: http://localhost:8000/public/index.html
echo.
echo Close this window when done.
pause
goto :eof

:stop
echo.
echo ==========================================
echo   STOPPING FOODIE ORANGE SERVERS
echo ==========================================

set STOP_RESULT=NONE
for /f %%r in ('powershell -NoProfile -Command "$ports=@(5000,8000); $pids=Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue ^| Where-Object { $ports -contains $_.LocalPort } ^| Select-Object -ExpandProperty OwningProcess -Unique; if($pids){$pids ^| ForEach-Object { Stop-Process -Id $_ -Force -ErrorAction SilentlyContinue }; Write-Output 'STOPPED'} else {Write-Output 'NONE'}"') do set STOP_RESULT=%%r

if /I "%STOP_RESULT%"=="NONE" (
	echo No running server processes found on ports 5000/8000.
) else (
	echo Servers stopped on ports 5000/8000.
)

echo.
echo Tip: Start again with Start-Servers.bat
exit /b 0
