@echo off
REM Mirror of bash updateAll/updateTools/updateRepos (see ~/.bash_aliases). Windows/clink only.
setlocal

if /i "%~1"=="tools" (
	call :updateTools
) else if /i "%~1"=="repos" (
	call :updateRepos
) else (
	call :updateAll
)

endlocal
exit /b 0

:updateAll
where winget >nul 2>&1 && call :run_with_header "WINGET UPGRADE --ALL" "winget upgrade --all"
call :updateTools
call :updateRepos
exit /b 0

:updateTools
where gh >nul 2>&1 && call :run_with_header "GH EXTENSION UPGRADE --ALL" "gh extension upgrade --all"
where uv >nul 2>&1 && call :run_with_header "UV TOOL UPGRADE --ALL" "uv tool upgrade --all"
exit /b 0

:updateRepos
where gittyup >nul 2>&1 || (
	echo warning: 'gittyup' not found - can't update git repositories. Install it via 'uv tool install gittyup'.
	exit /b 0
)
for %%D in (
	"%USERPROFILE%\Git"
	"%USERPROFILE%\.pyenv"
	"%USERPROFILE%\.adr-tools"
) do if exist "%%~D\" gittyup --ignore-all-changes --sync "%%~D"
exit /b 0

REM Execute a command (%~2) under an uppercase header (%~1); mirrors bash __run_with_header.
:run_with_header
echo.
echo [%~1]
%~2
exit /b 0
