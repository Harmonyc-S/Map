@echo off
title MerantheMapping - Create Pull Request
echo ============================================
echo   Create a Pull Request
echo ============================================
echo.
echo This will open GitHub in your browser so you can
echo submit your changes for review.
echo.

cd /d "%~dp0.."

for /f "tokens=*" %%b in ('git branch --show-current') do set CURRENT_BRANCH=%%b

if "%CURRENT_BRANCH%"=="master" (
    echo ERROR: You are on the master branch.
    echo You need to be on an edit branch to create a PR.
    echo Run "2_new_branch.bat" first.
    pause
    exit /b 1
)

:: Get the fork remote URL to extract the username
for /f "tokens=*" %%u in ('git remote get-url origin') do set REMOTE_URL=%%u

:: Extract username from URL. Handles both formats:
::   https://github.com/USERNAME/Map(.git)
::   git@github.com:USERNAME/Map(.git)
:: Note: "for /f delims=/" collapses consecutive slashes, so we can't just
:: take token 4 of the https URL -- "//" counts as one delimiter.
set "GH_PATH=%REMOTE_URL%"
set "GH_PATH=%GH_PATH:https://github.com/=%"
set "GH_PATH=%GH_PATH:http://github.com/=%"
set "GH_PATH=%GH_PATH:git@github.com:=%"
for /f "tokens=1 delims=/" %%u in ("%GH_PATH%") do set GITHUB_USER=%%u

if "%GITHUB_USER%"=="" (
    echo ERROR: Could not determine your GitHub username from the "origin" remote.
    echo   origin = %REMOTE_URL%
    echo Make sure "origin" points to your fork on GitHub.
    pause
    exit /b 1
)

echo Current branch: %CURRENT_BRANCH%
echo.
echo Make sure you have saved and pushed your work first!
echo (Run "3_save_work.bat" if you haven't)
echo.
echo Press any key to open the Pull Request page in your browser...
pause >nul

start https://github.com/EterniaDevelopment/Map/compare/master...%GITHUB_USER%:%CURRENT_BRANCH%

echo.
echo ============================================
echo   Browser opened!
echo ============================================
echo.
echo On the GitHub page:
echo   1. Add a title describing your changes
echo   2. Add any extra details in the description
echo   3. Click "Create pull request"
echo.
echo After your PR is reviewed and merged, run
echo "1_sync.bat" to pull the changes back down.
echo.
pause
