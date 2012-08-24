@ECHO OFF
IF "%1"=="" GOTO Stop

echo Building Linkage Mapper Release number %1

@ECHO ON
xcopy /E/I/Y ..\demo ..\LinkageMapper"%1"\LM_demo
xcopy /Y ..\toolbox\doc\*.pdf ..\LinkageMapper"%1"\*.pdf
xcopy /E/I/Y ..\toolbox\scripts ..\LinkageMapper"%1"\toolbox\scripts
xcopy /E/I/Y ..\toolbox\styles ..\LinkageMapper"%1"\toolbox\styles
xcopy /Y ..\toolbox\*.tbx ..\LinkageMapper"%1"\toolbox\*.tbx

del ..\LinkageMapper"%1"\toolbox\scripts\cc*.*
del ..\LinkageMapper"%1"\toolbox\scripts\s7*.*
del ..\LinkageMapper"%1"\toolbox\scripts\s6*.*
del ..\LinkageMapper"%1"\toolbox\scripts\bar*.*
del ..\LinkageMapper"%1"\toolbox\climate*.*
del ..\LinkageMapper"%1"\LM_demo\cc*.*
del ..\LinkageMapper"%1"\LM_demo\demoData\cc*.*
del ..\LinkageMapper"%1"\toolbox\*Plus.tbx
del ..\LinkageMapper"%1"\toolbox\*Extras.tbx

@ECHO OFF
if "%2"=="cc" GOTO CCCopy
if "%3"=="cc" GOTO CCCopy
if "%4"=="cc" GOTO CCCopy
GOTO CMTest

:CCCopy
@ECHO ON
xcopy /Y ..\toolbox\scripts\cc*.* ..\LinkageMapper"%1"\toolbox\scripts\cc*.*
xcopy /Y ..\toolbox\climate*.tbx ..\LinkageMapper"%1"\toolbox\climate*.tbx
xcopy /Y ..\demo\cc*.* ..\LinkageMapper"%1"\LM_demo\cc*.*
xcopy /Y ..\demo\demoData\cc*.* ..\LinkageMapper"%1"\LM_demo\demoData\cc*.*

:CMTest
@ECHO OFF
if "%2"=="cm" GOTO CMCopy
if "%3"=="cm" GOTO CMCopy
if "%4"=="cm" GOTO CMCopy
GOTO BMTest

:CMCopy
@ECHO ON
xcopy /Y ..\toolbox\scripts\s7_c*.* ..\LinkageMapper"%1"\toolbox\scripts\s7_c*.*
xcopy /Y ..\toolbox\*Extras.tbx ..\LinkageMapper"%1"\toolbox\*Extras.tbx
xcopy /Y ..\toolbox\doc\cen*.doc ..\LinkageMapper"%1"\cen*.doc

:BMTest
@ECHO OFF
if "%2"=="bm" GOTO BMCopy
if "%3"=="bm" GOTO BMCopy
if "%4"=="bm" GOTO BMCopy
GOTO Finish

:BMCopy
@ECHO ON
xcopy /Y ..\toolbox\scripts\bar*.* ..\LinkageMapper"%1"\toolbox\scripts\bar*.*
xcopy /Y ..\toolbox\scripts\s6_b*.* ..\LinkageMapper"%1"\toolbox\scripts\s6_b*.*
xcopy /Y ..\toolbox\*Extras.tbx ..\LinkageMapper"%1"\toolbox\*Extras.tbx
xcopy /Y ..\toolbox\doc\barr*.docx ..\LinkageMapper"%1"\barr*.docx
xcopy /Y ..\toolbox\doc\McRae*.docx ..\LinkageMapper"%1"\McRae*.docx

:Finish
@ECHO OFF
echo releaseNum = "%1" > ..\LinkageMapper"%1"\toolbox\scripts\lm_version.py
echo.
echo Finished building Linkage Mapper release number %1
if "%2"=="" GOTO END
echo Options: %2 %3 %4
GOTO END

:Stop
@ECHO OFF
echo.
echo Error: must supply a version string
echo syntax: lm_build (version) cm bm cc
echo example: lm_build 0.8.4 cm cc
echo.

:End