@echo off
REM Clink/CMD aliases derived from bash/.bash_aliases.
REM Notes:
REM - These are best-effort translations for CMD/Clink.
REM - Some Bash aliases rely on Linux tools and are intentionally omitted.

REM Color-related wrappers (work if GNU tools are in PATH)
doskey ls=ls --color=auto $*
doskey grep=grep --color=auto $*

REM Listing aliases
REM Bash had: la='LC_ALL=C ls --almost-all --group-directories-first --human-readable'
doskey la=ls --almost-all --group-directories-first --human-readable $*
doskey l=ls --almost-all --group-directories-first --human-readable --classify -1 $*
doskey ll=ls --almost-all --group-directories-first --human-readable --classify -1 -l $*

REM Utility aliases
doskey envsrt=set ^| sort
doskey dirtree=tree /a $*
doskey findstr=grep --ignore-case --recursive --files-with-matches $*

doskey dog=pygmentize -g $*
doskey winget=winget.exe $*
doskey pingw=ping -t www.web.de $*
doskey rmd=rm -rf $*
doskey pra=prek run --all-files $*
doskey uvpt=uv run pytest $*

REM lspath: show PATH entries one per line in CMD
doskey lspath=echo %PATH:;=^&echo.%

REM now: ISO-like UTC timestamp via PowerShell
REM Bash had nanoseconds; this keeps a close practical equivalent.
doskey now=powershell -NoProfile -Command "(Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fffffffK')"

REM Skipped from bash aliases (Bash/Linux-specific or unsafe to override in CMD):
REM - mkdir --parents (CMD mkdir already creates intermediate directories)
