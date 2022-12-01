REM This program will be used to start programs when machine is started
@ECHO off
REM %ProgramFiles% has 'C:\Program Files'
start "Chrome Profile1" "%ProgramFiles%\Google\Chrome\Application\chrome.exe" --proile-directory="Default"
start "Chrome Profile2" "%ProgramFiles%\Google\Chrome\Application\chrome.exe" --proile-directory="Profile 1"
start "Outlook" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Outlook"
REM %LOCALAPPDATA% contains C:|Users\210314\AppData\Local
start "Teams" "%LOCALAPPDATA%\Microsoft\Teams\Update.exe" --processStart "Teams.exe"

