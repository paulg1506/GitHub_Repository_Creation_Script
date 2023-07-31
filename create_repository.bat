@ECHO off
REM Script to create a new GitHub Repo using a curl POST request.
REM Paul Gardner
REM 28/05/2023

REM Gets the current working directory
FOR /F "tokens=*" %%g IN ('cd') do (SET CWD=%%g)

REM Strips the CWD down into the final folder name this will be name for Repo
REM Does not handle spaces in directory names - and _ work fine
FOR %%I IN (%CWD%) do (SET REPO=%%~nxI)

REM Asks user if Repo should be private defaults to yes
SET /P "PRIV=Do you want the Repository to be Private? <Y/n>: " || SET "PRIV=Y"

REM Sets PRIV to true or false based on user input
IF "%PRIV%"=="N" SET "PRIV=false"
IF "%PRIV%"=="n" SET "PRIV=false"
IF "%PRIV%"=="Y" SET "PRIV=true"
IF "%PRIV%"=="y" SET "PRIV=true"

REM Asks user to enter description for the Repo defaults to No Description Entered if empty
SET /P "DESC=Enter a description for this repository: " || SET "DESC=No Description Entered."

CLS
REM Echoes Collected Details
ECHO "To Confirm: "
ECHO "A repository wil be created named: %REPO%"
ECHO "The description will read: %DESC%"
ECHO "The repository will be Private: %PRIV%"

REM Prompts user to check if this is correct defaults to no
SET /P "CHECK=Is this correct? <y/N>: " || SET "CHECK=N"

REM If correct calls repo_create function Else calls no_create (See below) 
IF "%CHECK%"=="y" CALL :repo_create
IF "%CHECK%"=="Y" CALL :repo_create
IF "%CHECK%"=="N" CALL :no_create
IF "%CHECK%"=="n" CALL :no_create


REM The collected information is crafted into a json payload.
REM Function creates Repo by performing a curl POST request to github API.
:repo_create
SET "PAYLOAD="{\"name\": \"%REPO%\", \"description\": \"%DESC%\", \"private\": %PRIV%}""
curl -i -H "Authorization: token [INSERT TOKEN HERE]" -d %PAYLOAD% https://api.github.com/user/repos
SET /P "Z=Press [Enter] to exit."
EXIT


REM Informs the user the Repo will not be created.
:no_create
ECHO "OK the repository will not be created. Exiting."
SET /P "Z=Press [Enter] to exit."
EXIT  
