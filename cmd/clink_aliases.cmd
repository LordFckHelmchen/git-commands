@echo off
REM Clink/CMD aliases derived from bash/.bash_aliases.


REM ############################################################################
REM ### ALIASES TO MAKE BASH-LIKE COMMANDS AVAILABLE IN CMD
REM ############################################################################

REM CMD-native listing aliases, resembling the output of GNU ls with common options but don't require GNU 'ls'
doskey l=dir /a /b $*
doskey ll=dir /a $*

REM Text search aliases (CMD-native)
doskey grep=findstr /n /i $*

REM touch for cmd: create empty file or update timestamp
doskey touch=for %I in ($*) do @type nul >> "%~I"

doskey which=where $*


REM ############################################################################
REM ### UTILITY ALIASES
REM ############################################################################

REM Utility aliases
REM 'envsrt' is a simple alias to set, as CMD already sorts the variables by name.
doskey envsrt=set
doskey dirtree=tree /a $*

doskey dog=pygmentize -g $*
doskey pingw=ping -t www.web.de $*
doskey rmd=rmdir /s /q $*
doskey pra=prek run --all-files $*
doskey uvpt=uv run pytest $*

REM lspath: show PATH entries one per line in CMD
doskey lspath=for %P in ("%PATH:;=" "%") do @echo %~P

REM now: ISO-like UTC timestamp via PowerShell
REM Bash had nanoseconds; this keeps a close practical equivalent.
doskey now=powershell -NoProfile -Command "(Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fffffffK')"
