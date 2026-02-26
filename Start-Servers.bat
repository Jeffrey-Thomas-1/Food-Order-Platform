@echo off
REM Foodie Orange Pro - Start Both Servers
REM Simply double-click this file to start everything

color 0A
echo.
echo ==========================================
echo   FOODIE ORANGE PRO - SERVER LAUNCHER
echo ==========================================
echo.

REM Start Backend
echo [1/3] Starting Backend API on Port 5000...
start "Foodie Orange - Backend" cmd /k "cd /d "%CD%\Backend" && npm start"

REM Wait for backend to initialize
timeout /t 3 /nobreak

REM Start Frontend
echo [2/3] Starting Frontend Server on Port 8000...
start "Foodie Orange - Frontend" cmd /k "cd /d "%CD%\Frontend\public" && python -m http.server 8000"

REM Wait a moment
timeout /t 2 /nobreak

REM Open browser
echo [3/3] Opening browser...
timeout /t 1 /nobreak
start http://localhost:8000

echo.
echo ==========================================
echo   ✅ Servers Started Successfully!
echo ==========================================
echo.
echo Backend:  http://localhost:5000/api/health
echo Frontend: http://localhost:8000
echo.
echo Close this window when done.
pause
