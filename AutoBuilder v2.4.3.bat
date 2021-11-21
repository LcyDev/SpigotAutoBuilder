@echo off
setlocal EnableDelayedExpansion
SET file=spigot
SET name=Spigot
SET name2=Spigot and bukkit
call :setESC
ECHO.
ECHO %ESC%[1m%ESC%[33mStarting Spigot-BuildTools 1.8-1.17 downloader...%ESC%[0m
ECHO.
goto VARS



:VARS
SET JAVA16="C:\Program Files\EclipseAdoptium\jdk-16.0.2.7-openj9\bin\java.exe"
if exist %JAVA16% (
	ECHO  %ESC%[92mJava 16 binary: %JAVA16%%ESC%[0m
	ECHO.
) else (
	ECHO  %ESC%[31mJava 16 binary NOT FOUND: %JAVA16%%ESC%[0m
	ECHO.
)

SET JAVA11="C:\Program Files\EclipseAdoptium\jre-11.0.13.8-hotspot\bin\java.exe"
if exist %JAVA11% (
	ECHO  %ESC%[92mJava 11 binary: %JAVA11%%ESC%[0m
	ECHO.
) else (
	ECHO  %ESC%[31mJava 11 binary NOT FOUND: %JAVA11%%ESC%[0m
	ECHO.
)
SET JAVA8="C:\Program Files\EclipseAdoptium\jre-8.0.312.7-hotspot\bin\java.exe"
if exist %JAVA8% (
	ECHO  %ESC%[92mJava 8 binary: %JAVA8%%ESC%[0m
	ECHO.
) else (
	ECHO  %ESC%[31mJava 8 binary NOT FOUND: %JAVA8%%ESC%[0m
	ECHO.
)
SET BUKKIT=FALSE
if %BUKKIT%==TRUE ( 
	SET CRAFTBUKKIT=--compile craftbukkit
	SET file=bukkit
	SET name=Bukkit
	SET name2=Bukkit
	)
ECHO %ESC%[33mBukkitCompiler: %ESC%[91m%BUKKIT% %ESC%[96m(1.14+)
ECHO.
goto START

:START

ECHO %ESC%[1m%ESC%[33m[SPIGOT-BUILDTOOLS 1.8-1.18 DOWNLODER]%ESC%[0m
ECHO.
ECHO %ESC%[36mBuild the org.spigot.spigot jars 1.17-1.8?%ESC%[0m
ECHO %ESC%[91mValid: YES/NO, Yes/No, yes/no%ESC%[0m
ECHO.
set /p input="%ESC%[31m>> %ESC%[0m"
 if /i "%input%"=="" (
	ECHO.
	ECHO %ESC%[91mUnknown option.%ESC%[0m
	ECHO.
	goto :START
 )
 if %input%==yes goto BUILD
 if %input%==no goto EXIT
 if %input%==Yes goto BUILD
 if %input%==No goto EXIT
 if %input%==YES goto BUILD
 if %input%==NO goto EXIT
ECHO.
ECHO %ESC%[91mUnknown option.%ESC%[0m
ECHO.
goto START

:BUILD
if exist ./product/%file%-1.17.jar (
	ECHO.
	ECHO %ESC%[91m %name% 1.17 already built, skipping ...%ESC%[0m%ESC%[0m
	ECHO.
) ELSE (
	ECHO.
	ECHO %ESC%[92m Building %name% 1.17 ...%ESC%[0m
	ECHO %ESC%[46;30m
	%JAVA16% -jar BuildTools.jar --rev 1.17 --output-dir ./product %CRAFTBUKKIT%
	ECHO.
)
ECHO %ESC%[40;37m
if exist ./product/spigot-1.16.5.jar (
	ECHO.
	ECHO %ESC%[91m %name% 1.16.5 already built, skipping ...%ESC%[0m%ESC%[0m
	ECHO.
) ELSE (
	ECHO.
	ECHO %ESC%[92m Building %name% 1.16.5 ...%ESC%[0m
	ECHO %ESC%[46;30m
	%JAVA16% -jar BuildTools.jar --rev 1.16.5 --output-dir ./product %CRAFTBUKKIT%
	ECHO.
)
ECHO %ESC%[40;37m
if exist ./product/spigot-1.16.3.jar (
	ECHO.
	ECHO %ESC%[91m %name% 1.16.3 already built, skipping ...%ESC%[0m%ESC%[0m
	ECHO.
) ELSE (
	ECHO.
	ECHO %ESC%[92m Building %name% 1.16.3 ...%ESC%[0m
	ECHO %ESC%[46;30m
	%JAVA11% -jar BuildTools.jar --rev 1.16.3 --output-dir ./product %CRAFTBUKKIT%
	ECHO.
)
ECHO %ESC%[40;37m
if exist ./product/spigot-1.16.1.jar (
	ECHO.
	ECHO %ESC%[91m %name% 1.16.1 already built, skipping ...%ESC%[0m%ESC%[0m
	ECHO.
) ELSE (
	ECHO.
	ECHO %ESC%[92m Building %name% 1.16.1 ...%ESC%[0m
	ECHO %ESC%[46;30m
	%JAVA11% -jar BuildTools.jar --rev 1.16.1 --output-dir ./product %CRAFTBUKKIT%
	ECHO.
)
ECHO %ESC%[40;37m
if exist ./product/spigot-1.15.2.jar (
	ECHO.
	ECHO %ESC%[91m %name% 1.15.2 already built, skipping ...%ESC%[0m%ESC%[0m
	ECHO.
) ELSE (
	ECHO.
	ECHO %ESC%[92m Building %name% 1.15.2 ...%ESC%[0m
	ECHO %ESC%[46;30m
	%JAVA11% -jar BuildTools.jar --rev 1.15.2 --output-dir ./product %CRAFTBUKKIT%
	ECHO.
)
ECHO %ESC%[40;37m
if exist ./product/spigot-1.14.4.jar (
	ECHO.
	ECHO %ESC%[91m %name% 1.14.4 already built, skipping ...%ESC%[0m%ESC%[0m
	ECHO.
) ELSE (
	ECHO.
	ECHO %ESC%[92m Building %name% 1.14.4 ...%ESC%[0m
	ECHO %ESC%[46;30m
	%JAVA11% -jar BuildTools.jar --rev 1.14.4 --output-dir ./product %CRAFTBUKKIT%
	ECHO.
)
ECHO %ESC%[40;37m
if exist ./product/spigot-1.13.2.jar (
	ECHO.
	ECHO %ESC%[91m %name% 1.13.2 already built, skipping ...%ESC%[0m%ESC%[0m
	ECHO.
) ELSE (
	ECHO.
	ECHO %ESC%[92m Building %name2% 1.13.2 ...%ESC%[0m
	ECHO %ESC%[46;30m
	%JAVA11% -jar BuildTools.jar --rev 1.13.2 --output-dir ./product %CRAFTBUKKIT%
	ECHO.
)
ECHO %ESC%[40;37m
if exist ./product/spigot-1.12.2.jar (
	ECHO.
	ECHO %ESC%[91m %name% 1.12.2 already built, skipping ...%ESC%[0m%ESC%[0m
	ECHO.
) ELSE (
	ECHO.
	ECHO %ESC%[92m Building %name2% 1.12.2 ...%ESC%[0m
	ECHO %ESC%[46;30m
	%JAVA8% -jar BuildTools.jar --rev 1.12.2 --output-dir ./product %CRAFTBUKKIT%
	ECHO.
)
ECHO %ESC%[40;37m
if exist ./product/spigot-1.11.2.jar (
	ECHO.
	ECHO %ESC%[91m %name% 1.11.2 already built, skipping ...%ESC%[0m%ESC%[0m
	ECHO.
) ELSE (
	ECHO.
	ECHO %ESC%[92m Building %name2% 1.11.2. ...%ESC%[0m
	ECHO %ESC%[46;30m
	%JAVA8% -jar BuildTools.jar --rev 1.11.2 --output-dir ./product %CRAFTBUKKIT%
	ECHO.
)
ECHO %ESC%[40;37m
if exist ./product/spigot-1.10.2.jar (
	ECHO.
	ECHO %ESC%[91m %name% 1.10.2 already built, skipping ...%ESC%[0m%ESC%[0m
	ECHO.
) ELSE (
	ECHO.
	ECHO %ESC%[92m Building %name2% 1.10.2 ...%ESC%[0m
	ECHO %ESC%[46;30m
	%JAVA8% -jar BuildTools.jar --rev 1.10.2 --output-dir ./product %CRAFTBUKKIT%
	ECHO.
)
ECHO %ESC%[40;37m
if exist ./product/spigot-1.9.4.jar (
	ECHO.
	ECHO %ESC%[91m %name% 1.9.4 already built, skipping ...%ESC%[0m%ESC%[0m
	ECHO.
) ELSE (
	ECHO.
	ECHO %ESC%[92m Building %name2% 1.9.4 ...%ESC%[0m
	ECHO %ESC%[46;30m
	%JAVA8% -jar BuildTools.jar --rev 1.9.4 --output-dir ./product %CRAFTBUKKIT%
	ECHO.
)
ECHO %ESC%[40;37m
if exist ./product/spigot-1.8.8.jar (
	ECHO.
	ECHO %ESC%[91m %name% 1.8.8 already built, skipping ...%ESC%[0m%ESC%[0m
	ECHO.
) ELSE (
	ECHO.
	ECHO %ESC%[92m Building %name2% 1.8.8 ...%ESC%[0m
	ECHO %ESC%[46;30m
	%JAVA8% -jar BuildTools.jar --rev 1.8.8 --output-dir ./product %CRAFTBUKKIT%
	ECHO.
)
ECHO %ESC%[40;37m
if '%errorlevel%' == '0' ( goto FINISH ) else ( goto CRASH )


:EXIT
echo.
ECHO --------------
ECHO ^|%ESC%[1m%ESC%[91m Exiting... %ESC%[0m^|
ECHO --------------
TIMEOUT /T 10
exit

:FINISH
echo.
ECHO ----------------------
ECHO ^|%ESC%[1m%ESC%[92m Building finished^^! %ESC%[0m^|
ECHO ----------------------
echo.
pause
goto EXIT

:CRASH
ECHO -------------------------------
ECHO ^|%ESC%[1m%ESC%[31m ERROR: %ESC%[1m%ESC%[91mBUILDING HAS FAILED^^! %ESC%[0m^|
ECHO -------------------------------
echo.
pause
goto EXIT

:setESC
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set ESC=%%b
  exit /B 0
)