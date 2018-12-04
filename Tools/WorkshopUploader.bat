@ECHO OFF
ECHO Welcome to the workshop UPDATER tool.
ECHO Please log steam into the appropriate account before continuing,
ECHO and that the git folder is set to the correct branch, revision,
ECHO and that appropriate changes included if needed.
PAUSE
set sourcepath=%~dp0
:CONFIRMSOURCEPATH
cls
set /p confirmsourcepath="Is %sourcepath% the correct path to the source code folders that you intend to update on the workshop? (Y)es / (N)o
IF /I %confirmsourcepath%==Y GOTO GMODPATH
IF /I %confirmsourcepath%==N MANUALSETSOURCEPATH
ECHO.
ECHO That is not a valid option!
PAUSE
GOTO :CONFIRMSOURCEPATH
:MANUALSETSOURCEPATH
cls
set /p sourcepath="Please provide the full path, including trailing slash, to source code folders for compiling.
GOTO :CONFIRMSOURCEPATH
:GMODPATH
cls
REM We're going to check and see if gmodpath is set, and either confirm with the user, or have them change it.
IF DEFINED gmodpath (
  :GMODPATHQ
  set /p confirmgmodpath="Is %gmodpath% the correct path to gmad and gmpublish? (Y)es / (N)o
  IF /I %confirmgmodpath%==Y GOTO GMODPATHTESTS
  IF /I %confirmgmodpath%==N (
    REM clear the gmodpath variable and restart this block so that the check fails and prompts to be set.
    set gmodpath=
    GOTO GMODPATH
  )
  REM user didn't enter Y or N to the confirmation dialog. Tell them as such and go back to the question.
  ECHO.
  ECHO That is not a valid option!
  pause
  GOTO GMODPATHQ
) ELSE (
  set /p gmodpath="Please provide the full folder path to gmad and gmpublish, including a trailing slash"
)
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
  set sourcefolder="wire"
  set workshopid="160250458"
  GOTO EXECUTE
)
IF %M%==2 (
  set sourcefolder="advduplicator"
  set workshopid="163806212"
  GOTO EXECUTE
)
IF %M%==3 (
  set sourcefolder="advdupe2"
  set workshopid="773402917"
  GOTO EXECUTE
)
IF %M%==4 GOTO MANUALFOLDER
IF %M%==5 GOTO CONFIRMSOURCEPATH
IF %M%==6 GOTO EOF
ECHO.
ECHO That is not a valid option!
PAUSE
GOTO MENU
:MANUALFOLDER
cls
set /p sourcefolder="What is the name of the addon folder you wish to package and update?
cls
set /p confirmsourcefolder="To confirm, %sourcefolder% is what you wanted to package and update? (Y)es / (N)o / (C)ancel
IF /I %confirmsourcefolder%==Y GOTO EXECUTE
IF /I %confirmsourcefolder%==N GOTO MANUALFOLDER
IF /I %confirmsourcefolder%==C GOTO MENU
ECHO.
ECHO That wasn't a valid option!
PAUSE
GOTO MANUALFOLDER
:EXECUTE
cls
IF NOT EXIST %sourcefolder% (
  ECHO "%sourcefolder% folder doesn't exist here. Check your path!"
  pause
  GOTO MENU
)
ECHO Building %sourcefolder%.gma file...
%gmodpath%gmad.exe create -folder %sourcepath%\%sourcefolder%
:SETCHANGES
set changes=
set /p changes="Please provide the changelog for %sourcefolder% changes."
IF NOT DEFINED changes (
  ECHO.
  ECHO "You must enter changes"
  PAUSE
  GOTO SETCHANGES
)
:CHECKCHANGES
cls
ECHO %changes%
set /p confirmchanges="Is the above what you wanted for the changelog? (Y)es / (N)o / (C)ancel"
IF /I %confirmchanges%==Y GOTO PUBLISH
IF /I %confirmchanges%==N GOTO SETCHANGES
IF /I %confirmchanges%==C GOTO MENU
ECHO.
ECHO That wasn't a valid option!
PAUSE
GOTO CHECKCHANGES
:PUBLISH
%gmodpath%gmpublish.exe update -addon "%sourcepath%\%sourcefolder%.gma" -id %workshopid% -changes "%changes%"
PAUSE
set sourcefolder=
set workshopid=
GOTO MENU
:EOF
