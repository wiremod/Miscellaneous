@ECHO OFF
ECHO Please log steam into the wireteam account before continuing, and that the git folder is set to the correct branch, revision, and appropriate changes are included if needed.
PAUSE
set sourcepath=%~dp0
:CONFIRMSOURCEPATH
cls
set /p confirmsourcepath="Is %sourcepath% the correct path to the source code folders for wire, adv dupe, and/or adv dupe 2?
IF /I %confirmsourcepath%==Y GOTO GMODPATH
IF /I %confirmsourcepath%==N SETSOURCEPATH
ECHO.
ECHO That wasn't a valid option!
PAUSE
GOTO :CONFIRMSOURCEPATH
:SETSOURCEPATH
cls
set /p sourcepath="Please provide the full path, including trailing slash, to source code folders for compiling.
GOTO :CONFIRMSOURCEPATH
:GMODPATH
cls
set /p gmodpath="Please provide the full folder path to gmad and gmpublish, including a trailing slash"
IF NOT EXIST %gmodpath%gmad.exe ECHO "gmad.exe doesn't exist at this path!" && PAUSE && GOTO CONFIRMSOURCEPATH
IF NOT EXIST %gmodpath%gmpublish.exe ECHO "gmpublish.exe doesn't exist at this path!" && PAUSE && GOTO CONFIRMSOURCEPATH
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
ECHO 4 - Check or Change Paths
ECHO 5 - EXIT
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
IF %M%==4 GOTO CONFIRMSOURCEPATH
IF %M%==5 GOTO EOF
ECHO.
ECHO That wasn't a valid option!
PAUSE
GOTO MENU
:EXECUTE
cls
IF NOT EXIST %sourcefolder% ECHO "%sourcefolder% folder doesn't exist here. Check your path!" && GOTO MENU
ECHO Building %sourcefolder%.gma file...
%gmodpath%gmad.exe create -folder %sourcepath%\%sourcefolder%
:SETCHANGES
set changes=
set /p changes="Please provide the changelog for %sourcefolder% changes."
IF NOT DEFINED changes ECHO. && ECHO "You must enter changes" && PAUSE && GOTO SETCHANGES
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
