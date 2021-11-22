@echo off
setlocal EnableDelayedExpansion
TITLE AutoBuilder v3.2.6
call :setESC
call :CONFIG
call :SCRIPT
goto START


:CONFIG
::##########################
:: Prevent compiling.
SET DEBUG=FALSE

:: Java 16-17 or higher is required
:: Recommended Java 16 as for now (1.17+)
SET JDK17="C:\Program Files\EclipseAdoptium\jdk-16.0.2.7-openj9\bin\java.exe"
:: Java 8-17 or higher are valid
:: Recommended Java 16 (1.16.5)
SET JDK16="C:\Program Files\EclipseAdoptium\jdk-16.0.2.7-openj9\bin\java.exe"
:: Java 8-15 is valid
:: Recommended Java 11 (1.13-1.16.4)
SET JDK11="C:\Program Files\EclipseAdoptium\jre-11.0.13.8-hotspot\bin\java.exe"
:: Java 8-10 is valid
:: Recommended Java 8 (1.8-1.12.2)
SET JDK8="C:\Program Files\EclipseAdoptium\jre-8.0.312.7-hotspot\bin\java.exe"

:: Output folder path.
SET "OUTPUT=./product"

:: Compile Craftbukkit?
SET CRAFTBUKKIT=TRUE
:: Compile Spigot?
SET SPIGOT=TRUE

::##########################

SET 1.17.1=false
SET 1.17=TRUE
::
SET 1.16.5=TRUE
SET 1.16.4=false
SET 1.16.3=TRUE
SET 1.16.2=flase
SET 1.16.1=TRUE
SET 1.16=false
::
SET 1.15.2=TRUE
SET 1.15.1=false
SET 1.15=false
::
SET 1.14.4=TRUE
SET 1.14.3=false
SET 1.14.2=false
SET 1.14.1=false
SET 1.14=false
::
SET 1.13.2=TRUE
SET 1.13.1=false
SET 1.13=false
::
SET 1.12.2=TRUE
SET 1.12.1=false
SET 1.12=false
::
SET 1.11.2=TRUE
SET 1.11.1=false
SET 1.11=false
::
SET 1.10.2=TRUE
SET 1.10=false
::
SET 1.9.4=TRUE
SET 1.9.2=false
SET 1.9=false
::
SET 1.8.8=TRUE
SET 1.8.7=false
SET 1.8.6=false
SET 1.8.5=false
SET 1.8.4=false
SET 1.8.3=false
SET 1.8=false

::##########################

:::: END CONFIGURATION -- DON'T TOUCH ANYTHING BELOW THIS LINE!
goto :eof




:SCRIPT
ECHO.
ECHO -----------------------------------------------
ECHO ^| %ESC%[1m%ESC%[33mStarting %name%-BuildTools 1.8-1.17 downloader...%ESC%[0m ^|
ECHO -----------------------------------------------
ECHO.

if exist %JDK17% (
	ECHO  %ESC%[92mJava 17 binary: %JDK17%%ESC%[0m
	ECHO.
) else (
	ECHO  %ESC%[31mJava 17 binary NOT FOUND: %JDK17%%ESC%[0m
	ECHO.
)

if exist %JDK16% (
	ECHO  %ESC%[92mJava 16 binary: %JDK16%%ESC%[0m
	ECHO.
) else (
	ECHO  %ESC%[31mJava 16 binary NOT FOUND: %JDK16%%ESC%[0m
	ECHO.
)
if exist %JDK11% (
	ECHO  %ESC%[92mJava 11 binary: %JDK11%%ESC%[0m
	ECHO.
) else (
	ECHO  %ESC%[31mJava 11 binary NOT FOUND: %JDK11%%ESC%[0m
	ECHO.
)
if exist %JDK8% (
	ECHO  %ESC%[92mJava 8 binary: %JDK8%%ESC%[0m
	ECHO.
) else (
	ECHO  %ESC%[31mJava 8 binary NOT FOUND: %JDK8%%ESC%[0m
	ECHO.
)
	ECHO.
	ECHO %ESC%[33mBukkitCompiler: %ESC%[91m%CRAFTBUKKIT% %ESC%[96m(1.14+)
	ECHO.
	ECHO.



SET packagemc=org.spigotmc.spigot
SET packagebk=org.bukkit.craftbukkit
if /I "%SPIGOT%"=="true" (
	if /I "!CRAFTBUKKIT!"=="false" (
		set package=%packagemc%
		set file=spigot
		set name=Spigot
		goto :eof
	)
	if /I "!CRAFTBUKKIT!"=="true" (
		set package=%packagemc% and %packagebk% ^(1.8-1.17^)
		set file=both
		set "name=Spigot ^& CraftBukkit"
		goto :eof
	)
)
if /I "%SPIGOT%"=="false" (
	if /I "!CRAFTBUKKIT!"=="true" (
		set package=%packagebk%
		set file=craftbukkit
		set name=CraftBukkit
		goto :eof
	)
	if /I "!CRAFTBUKKIT!"=="false" (
		set package=%packagemc% and %packagebk% ^(1.8-1.13^)
		set file=both
		set mode=legacy
		set "name=Spigot ^& CraftBukkit"
		goto :eof
	)
)
goto :eof

::
:: Promt the user to start building.
::
:START
ECHO %ESC%[1m%ESC%[33m[%name%-BUILDTOOLS 1.8-1.18 DOWNLODER]%ESC%[0m
ECHO.
ECHO %ESC%[36mBuild the %package% jars ^?%ESC%[0m
ECHO %ESC%[91mValid: Yes or No ^| Custom %ESC%[0m
ECHO.
set /p input="%ESC%[31m>> %ESC%[0m"
 if "%input%"=="" (
	ECHO.
	ECHO.
	ECHO %ESC%[91mUnknown option.%ESC%[0m
	ECHO.
	ECHO.
	goto START
 )
 if /i "%input%"=="yes" goto COMPILER
 if /i "%input%"=="no" goto EXIT
 if /i "%input%"=="custom" ( goto CUSTOM )
	ECHO.
	ECHO.
	ECHO %ESC%[91mUnknown option.%ESC%[0m
	ECHO.
	ECHO.
goto START


:CUSTOM
	ECHO.
	ECHO Insert a valid spigot build to compile.
	ECHO https://hub.spigotmc.org/versions/
	ECHO.
	set /p input1="%ESC%[31m>> %ESC%[0m"
	SET build=%input1%
	echo %build%
	ECHO.
	
	ECHO Insert which JDK to use.
	ECHO JDK17, JDK16, JDK11, JDK8 ^(See :CONFIG^)
	ECHO.
	set /p input2="%ESC%[31m>> %ESC%[0m"
	SET MYJDK=!%input2%!
	ECHO.
	ECHO. %ESC%[92mDONE. Now select yes in menu.
	ECHO.
	set CUSTOM=true
	GOTO START

::
:: Manages version compiling.
::
:COMPILER
if /I "!CUSTOM!"=="true" ( set "version=%build%" & set "JAVA=%MYJDK%" & call :DETECT )
if /I "!1.17.1!"=="true" ( set "version=1.17.1" & set "JAVA=%JDK17%" & call :DETECT )
if /I "!1.17!"=="true" ( set "version=1.17" & set "JAVA=%JDK17%" & call :DETECT )
if /I "!1.16.5!"=="true" ( set "version=1.16.5" & set "JAVA=%JDK16%" & call :DETECT )
if /I "!1.16.4!"=="true" ( set "version=1.16.4" & set "JAVA=%JDK11%" & call :DETECT )
if /I "!1.16.3!"=="true" ( set "version=1.16.3" & set "JAVA=%JDK11%" & call :DETECT )
if /I "!1.16.2!"=="true" ( set "version=1.16.2" & set "JAVA=%JDK11%" & call :DETECT )
if /I "!1.16.1!"=="true" ( set "version=1.16.1" & set "JAVA=%JDK11%" & call :DETECT )
if /I "!1.16!"=="true" ( set "version=1.16" & set "JAVA=%JDK11%" & call :DETECT )
if /I "!1.15.2!"=="true" ( set "version=1.15.2" & set "JAVA=%JDK11%" & call :DETECT )
if /I "!1.15.1!"=="true" ( set "version=1.15.1" & set "JAVA=%JDK11%" & call :DETECT )
if /I "!1.15!"=="true" ( set "version=1.15" & set "JAVA=%JDK11%" & call :DETECT )
if /I "!1.14.4!"=="true" ( set "version=1.14.4" & set "JAVA=%JDK11%" & call :DETECT )
if /I "!1.14.3!"=="true" ( set "version=1.14.3" & set "JAVA=%JDK11%" & call :DETECT )
if /I "!1.14.2!"=="true" ( set "version=1.14.2" & set "JAVA=%JDK11%" & call :DETECT )
if /I "!1.14.1!"=="true" ( set "version=1.14.1" & set "JAVA=%JDK11%" & call :DETECT )
if /I "!1.14!"=="true" ( set "version=1.14" & set "JAVA=%JDK11%" & call :DETECT )
if /I "!1.13.2!"=="true" ( set "version=1.13.2" & set "JAVA=%JDK11%" & call :DETECT )
if /I "!1.13.1!"=="true" ( set "version=1.13.1" & set "JAVA=%JDK11%" & call :DETECT )
if /I "!1.13!"=="true" ( set "version=1.13" & set "JAVA=%JDK11%" & call :DETECT )
if /I "!1.12.2!"=="true" ( set "version=1.12.2" & set "JAVA=%JDK8%" & call :DETECT )
if /I "!1.12.1!"=="true" ( set "version=1.12.1" & set "JAVA=%JDK8%" & call :DETECT )
if /I "!1.12!"=="true" ( set "version=1.12" & set "JAVA=%JDK8%" & call :DETECT )
if /I "!1.11.2!"=="true" ( set "version=1.11.2" & set "JAVA=%JDK8%" & call :DETECT )
if /I "!1.11.1!"=="true" ( set "version=1.11.1" & set "JAVA=%JDK8%" & call :DETECT )
if /I "!1.11!"=="true" ( set "version=1.11" & set "JAVA=%JDK8%" & call :DETECT )
if /I "!1.10.2!"=="true" ( set "version=1.10.2" & set "JAVA=%JDK8%" & call :DETECT )
if /I "!1.10!"=="true" ( set "version=1.10" & set "JAVA=%JDK8%" & call :DETECT )
if /I "!1.9.4!"=="true" ( set "version=1.9.4" & set "JAVA=%JDK8%" & call :DETECT )
if /I "!1.9.2!"=="true" ( set "version=1.9.2" & set "JAVA=%JDK8%" & call :DETECT )
if /I "!1.9!"=="true" ( set "version=1.9" & set "JAVA=%JDK8%" & call :DETECT )
if /I "!1.9.4!"=="true" ( set "version=1.9.4" & set "JAVA=%JDK8%" & call :DETECT )
if /I "!1.8.8!"=="true" ( set "version=1.8.8" & set "JAVA=%JDK8%" & call :DETECT )
if /I "!1.8.7!"=="true" ( set "version=1.8.7" & set "JAVA=%JDK8%" & call :DETECT )
if /I "!1.8.6!"=="true" ( set "version=1.8.6" & set "JAVA=%JDK8%" & call :DETECT )
if /I "!1.8.5!"=="true" ( set "version=1.8.5" & set "JAVA=%JDK8%" & call :DETECT )
if /I "!1.8.4!"=="true" ( set "version=1.8.4" & set "JAVA=%JDK8%" & call :DETECT )
if /I "!1.8.3!"=="true" ( set "version=1.8.3" & set "JAVA=%JDK8%" & call :DETECT )
if /I "!1.8!"=="true" ( set "version=1.8" & set "JAVA=%JDK8%" & call :DETECT )
if '%errorlevel%' == '0' ( goto FINISH ) else ( goto CRASH )

::
::
:: Automatically detect the already built jars.
::
:DETECT
if "%file%"=="both" (
	if exist "%output%/spigot-%version%.jar" (
		if exist "%output%/craftbukkit-%version%.jar" (
			set skipfinal=both
			call :skip
			goto :eof
		) else (
			set skipfinal=Spigot
			set final=CraftBukkit
			set artifact=--compile craftbukkit
			call :skip
			call :build
			goto :eof
		)
	)
	if exist "%output%/craftbukkit-%version%.jar" (
		if exist "%output%/spigot-%version%.jar" (
			set skipfinal=both
			call :skip
			goto :eof
		) else (
			set skipfinal=CraftBukkit
			set final=Spigot
			set artifact=--compile spigot
			call :skip
			call :build
			goto :eof
		)
	) else (
		set "final=%name%"
		set artifact=--compile spigot --compile craftbukkit
		call :build
		goto :eof
	)
) else (
	if exist "%output%/%file%-%version%.jar" (
		set skipfinal=%name%
		call :skip
		goto :eof
	) else (
		set final=%name%
		set artifact=--compile %file%
		call :build
		goto :eof
	)
)
goto :eof

::
:: Automatically sort the skipping build message.
::
:SKIP
if "%skipfinal%"=="both" (
	ECHO.
	ECHO %ESC%[91m %name% %version% already builded, skipping ...%ESC%[0m%ESC%[0m
	ECHO.
	goto :eof
) else (
	ECHO.
	ECHO %ESC%[91m %skipfinal% %version% already built, skipping ...%ESC%[0m%ESC%[0m
	ECHO.
	goto :eof
)
goto :eof

::
:: Automatically compile the asked jar..
::
:BUILD
	ECHO %ESC%[40;37m
	ECHO.
	ECHO %ESC%[92m Building %final% %version% ...%ESC%[0m
	SET "RUN=%JAVA% -jar BuildTools.jar --rev %version% %artifact% --output-dir "%OUTPUT%""
	ECHO %ESC%[46;30m
	ECHO CMD: %RUN%
	if /I "%DEBUG%"=="false" ( %RUN% )
	ECHO.
	ECHO %ESC%[40;37m
if not '%errorlevel%' == '0' (
	ECHO %ESC%[40;37m
	ECHO ---------------------------------------------
	ECHO %ESC%[1m%ESC%[31m ERROR: %ESC%[1m%ESC%[91mBUILDING %name% %version% HAS FAILED^! %ESC%[0m
	ECHO ---------------------------------------------
	ECHO %ESC%[40;37m
	TIMEOUT /T 15
)
goto :eof

::
:: Assign Per-line color manager.
::
:setESC
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set ESC=%%b
  exit /B 0
)

::
:: Finished compiling.
::
:FINISH
ECHO %ESC%[40;37m
ECHO ----------------------
ECHO ^|%ESC%[1m%ESC%[92m Building finished^! %ESC%[0m^|
ECHO ----------------------
ECHO %ESC%[40;37m
echo %ESC%[91m
pause
goto EXIT

::
:: Crashed while compiling.
::
:CRASH
ECHO %ESC%[40;37m
ECHO ------------------------------
ECHO ^|%ESC%[1m%ESC%[31m ERROR: %ESC%[1m%ESC%[91mBUILDING HAS FAILED^! %ESC%[0m^|
ECHO ------------------------------
ECHO %ESC%[40;37m
echo %ESC%[91m
pause
goto EXIT

::
:: Exit the script.
::
:EXIT
ECHO %ESC%[40;37m
ECHO --------------
ECHO ^|%ESC%[1m%ESC%[91m Exiting... %ESC%[0m^|
ECHO --------------
ECHO %ESC%[40;37m
echo %ESC%[91m
TIMEOUT /T 10
exit
