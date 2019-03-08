@ECHO OFF
ECHO Welcome to the workshop UPDATER tool.
ECHO Please log steam into the appropriate account before continuing,
ECHO and that the git folder is set to the correct branch, revision,
ECHO and that appropriate changes included if needed.
PAUSE
REM %~dp0 grabs the current full path that the script resides in
set sourcepath=%~dp0
:CONFIRMSOURCEPATH
cls
set /p confirmsourcepath="Is %sourcepath% the correct path to the source code folders that you intend to update on the workshop? (Y)es / (N)o - "
IF /I %confirmsourcepath%==Y GOTO GMODPATH
IF /I %confirmsourcepath%==N MANUALSETSOURCEPATH
ECHO.
ECHO That is not a valid option!
PAUSE
GOTO :CONFIRMSOURCEPATH
:MANUALSETSOURCEPATH
cls
set /p sourcepath="Please provide the full path, including trailing slash, to source code folders for compiling. - "
GOTO :CONFIRMSOURCEPATH
:GMODPATH
cls
IF NOT DEFINED gmodpath GOTO DEFINEGMODPATH
set /p confirmgmodpath="Is %gmodpath% the correct path to gmad and gmpublish? (Y)es / (N)o - "
IF /I %confirmgmodpath%==Y GOTO GMODPATHTESTS
IF /I %confirmgmodpath%==N (
  REM clear the gmodpath variable and restart this block so that the check fails and prompts to be set.
  set gmodpath=
  GOTO GMODPATH
)
  ECHO.
  ECHO That is not a valid option!
  pause
  GOTO GMODPATH
:DEFINEGMODPATH
cls
set /p gmodpath="Please provide the full folder path to gmad and gmpublish, including a trailing slash - "
GOTO GMODPATH
:GMODPATHTESTS
IF NOT EXIST %gmodpath%gmad.exe (
  ECHO "gmad.exe doesn't exist at %gmodpath%!"
  PAUSE
  set gmodpath=
  GOTO GMODPATH
)
IF NOT EXIST %gmodpath%gmpublish.exe (
  ECHO "gmpublish.exe doesn't exist at %gmodpath%!"
  PAUSE
  set gmodpath=
  GOTO GMODPATH
)
:MENU
cls
ECHO.
ECHO ...............................................
ECHO PRESS THE NUMBER FOR THE OPTION YOU WANT TO DO
ECHO Remember, this script will NOT work if you are
ECHO not logged into WireTeam with steam!
ECHO ...............................................
ECHO.
ECHO 1 - Wiremod workshop update
ECHO 2 - Adv Duplicator workshop update
ECHO 3 - Adv Dupe 2 workshop update
ECHO 4 - Enter your own workshop folder for update
ECHO 5 - Check or Change Paths
ECHO 6 - EXIT
ECHO.
SET /P M="Type the option, then press ENTER:"
IF %M%==1 (
  set sourcefolder=wire
  set workshopid="160250458"
  GOTO :PACKQUESTION
)
IF %M%==2 (
  set sourcefolder=advduplicator
  set workshopid="163806212"
  GOTO :PACKQUESTION
)
IF %M%==3 (
  set sourcefolder=advdupe2
  set workshopid="773402917"
  GOTO :PACKQUESTION
)
IF %M%==4 GOTO MANUALFOLDER
IF %M%==5 GOTO CONFIRMSOURCEPATH
IF %M%==6 GOTO EOF
ECHO.
ECHO That is not a valid option!
PAUSE
GOTO MENU
:MANUALFOLDER
REM Let's clear these variables, just in case, so there's no accidents.
set sourcefolder=
set workshopid=
cls
set /p sourcefolder="Please provide the name of the addon folder without paths, or the name of the gma file without the extension, that you wish to update - "
:CONFIRMPARAMETERS
cls
set /p workshopid="What is the workshop ID of the addon that you wish to package and update? - "
set /p confirmsourcefolder="To confirm, %sourcefolder% is the addon, and %workshopid% is the workshop ID that you want to package and update? (Y)es / (N)o / (C)ancel - "
IF /I %confirmsourcefolder%==Y GOTO PACKQUESTION
IF /I %confirmsourcefolder%==N GOTO MANUALFOLDER
IF /I %confirmsourcefolder%==C GOTO MENU
ECHO.
ECHO That wasn't a valid option!
PAUSE
GOTO CONFIRMPARAMETERS
:PACKQUESTION
set packgma=
cls
set /p packgma="Do you need to pack the gma from source? - "
IF /I %packgma%==Y GOTO EXECUTEPACK
IF /I %packgma%==N GOTO SETCHANGES
IF /I %packgma%==C GOTO MENU
IF NOT EXIST %sourcefolder% (
  ECHO "%sourcefolder% folder doesn't exist here. Check your path or the addon name!"
  pause
  GOTO PACKQUESTION
)
:EXECUTEPACK
ECHO Building %sourcefolder%.gma file...
%gmodpath%gmad.exe create -folder "%sourcepath%%sourcefolder%"
:SETCHANGES
set changes=
set /p changes="Please provide the changelog for %sourcefolder% changes. - "
IF NOT DEFINED changes (
  ECHO.
  ECHO "You must enter changes"
  PAUSE
  GOTO SETCHANGES
)
:CHECKCHANGES
cls
ECHO %changes%
set /p confirmchanges="Is the above what you wanted for the changelog? (Y)es / (N)o / (C)ancel - "
IF /I %confirmchanges%==Y GOTO PUBLISH
IF /I %confirmchanges%==N GOTO SETCHANGES
IF /I %confirmchanges%==C GOTO MENU
ECHO.
ECHO That wasn't a valid option!
PAUSE
GOTO CHECKCHANGES
:PUBLISH
%gmodpath%gmpublish.exe update -addon "%sourcepath%%sourcefolder%.gma" -id %workshopid% -changes "%changes%"
PAUSE
set sourcefolder=
set workshopid=
GOTO MENU
:EOF
