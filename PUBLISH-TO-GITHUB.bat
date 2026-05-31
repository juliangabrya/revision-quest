@echo off
title Publish Revision Quest to GitHub
setlocal
set "GH=C:\Program Files\GitHub CLI\gh.exe"
if not exist "%GH%" set "GH=gh"
cd /d "%~dp0"

echo ============================================================
echo   PUBLISH REVISION QUEST TO GITHUB
echo ============================================================
echo.
echo Step 1: Logging you in to GitHub.
echo   - Choose: GitHub.com  ^>  HTTPS  ^>  Login with a web browser
echo   - Copy the one-time code into the browser window that opens.
echo.
"%GH%" auth status >nul 2>&1
if errorlevel 1 (
  "%GH%" auth login
) else (
  echo   Already logged in - skipping.
)
echo.
echo Step 2: Creating the repository and uploading the games...
"%GH%" repo create revision-quest --public --source=. --remote=origin --push
echo.
echo Step 3: Turning on GitHub Pages...
for /f "delims=" %%u in ('"%GH%" api user --jq .login') do set "OWNER=%%u"
"%GH%" api --method POST "repos/%OWNER%/revision-quest/pages" -f "source[branch]=main" -f "source[path]=/" >nul 2>&1
echo.
echo ============================================================
echo   DONE!
echo   Code:  https://github.com/%OWNER%/revision-quest
echo   PLAY:  https://%OWNER%.github.io/revision-quest/
echo   (Pages can take 1-2 minutes to go live the first time.)
echo.
echo   If the PLAY link 404s, open the repo - Settings - Pages,
echo   set Branch = main / (root), and Save.
echo ============================================================
echo.
pause
