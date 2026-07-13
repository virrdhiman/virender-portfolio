@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM Run from personal\, virender-portfolio\, or brandtrove-website\
set "ROOT=%~dp0"
if exist "%ROOT%virender-portfolio\.git" (
  set "PERSONAL=%ROOT%"
) else if exist "%ROOT%..\virender-portfolio\.git" (
  set "PERSONAL=%ROOT%..\"
) else (
  set "PERSONAL=%ROOT%"
)

echo ============================================================
echo   GIT PUSH — personal sites
echo ============================================================
echo.
echo   [1] virender-portfolio only
echo   [2] brandtrove-website only
echo   [3] Both repos
echo   [4] Create NEW GitHub repo from THIS folder
echo.
set /p CHOICE=Choose 1-4: 

if "%CHOICE%"=="1" goto VIRENDER
if "%CHOICE%"=="2" goto BRANDTROVE
if "%CHOICE%"=="3" goto BOTH
if "%CHOICE%"=="4" goto NEWREPO
echo Invalid choice.
pause
exit /b 1

:VIRENDER
call :PushRepo "%PERSONAL%virender-portfolio" "Update virender.in portfolio"
goto END

:BRANDTROVE
call :PushRepo "%PERSONAL%brandtrove-website" "Update brandtroveglobal.com"
goto END

:BOTH
call :PushRepo "%PERSONAL%virender-portfolio" "Update virender.in portfolio"
call :PushRepo "%PERSONAL%brandtrove-website" "Update brandtroveglobal.com"
goto END

:NEWREPO
set /p REPONAME=New repo name (e.g. my-project): 
if "%REPONAME%"=="" (
  echo Repo name required.
  pause
  exit /b 1
)
set /p VISIBILITY=Visibility public/private [public]: 
if "%VISIBILITY%"=="" set VISIBILITY=public
if /I not "%VISIBILITY%"=="private" set VISIBILITY=public

if not exist ".git" (
  git init
  git -c user.name="Virender Dhiman" -c user.email="virender@virender.in" add -A
  git -c user.name="Virender Dhiman" -c user.email="virender@virender.in" commit -m "Initial commit"
)

gh repo create %REPONAME% --%VISIBILITY% --source=. --remote=origin --push
if errorlevel 1 (
  echo Failed. Check: gh auth status
  pause
  exit /b 1
)
echo Created: https://github.com/virrdhiman/%REPONAME%
goto END

:PushRepo
set "REPO=%~1"
set "DEFAULT_MSG=%~2"
if not exist "%REPO%\.git" (
  echo SKIP: not a git repo — %REPO%
  exit /b 0
)
pushd "%REPO%" >nul
echo.
echo ---- %REPO% ----
git status -sb
git add -A
git diff --cached --quiet
if errorlevel 1 (
  set /p MSG=Commit message [%DEFAULT_MSG%]: 
  if "!MSG!"=="" set "MSG=%DEFAULT_MSG%"
  git -c user.name="Virender Dhiman" -c user.email="virender@virender.in" commit -m "!MSG!"
  if errorlevel 1 (
    echo Commit failed.
    popd >nul
    exit /b 1
  )
) else (
  echo No changes to commit.
)
git rev-parse --abbrev-ref --symbolic-full-name @{u} >nul 2>&1
if errorlevel 1 (
  git push -u origin HEAD
) else (
  git push
)
if errorlevel 1 (
  echo Push failed for %REPO%
  popd >nul
  exit /b 1
)
echo OK: pushed
popd >nul
exit /b 0

:END
echo.
echo Done.
pause
endlocal
