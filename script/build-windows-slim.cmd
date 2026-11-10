@echo off
setlocal
if "%~1"=="" (
  echo Usage: %~nx0 Qt-msvc2022_64-directory [vcvars64.bat]
  exit /b 2
)
if not "%~2"=="" (
  call "%~2"
  if errorlevel 1 exit /b 1
)
if not "%VSCMD_ARG_TGT_ARCH%"=="x64" (
  echo Run in an x64 Native Tools prompt or supply vcvars64.bat.
  exit /b 2
)
set "PATH=%~1\bin;%PATH%"
set "JQTSLIM=1"
set "JQTFAT="
set "JQTWEBKIT="
set "NO_OPENGL="
set "NO_WEBENGINE="
where nmake >nul 2>nul
if errorlevel 1 exit /b 2
if not exist "%~1\bin\qmake.exe" exit /b 2
"%~1\bin\qmake.exe" -query QT_VERSION | findstr /l /x "6.10.3" >nul
if errorlevel 1 (
  echo This recipe requires Qt 6.10.3.
  exit /b 2
)
pushd "%~dp0..\lib"
if errorlevel 1 exit /b 1
"%~1\bin\qmake.exe" lib.pro
if errorlevel 1 goto fail
nmake
if errorlevel 1 goto fail
popd
pushd "%~dp0..\main"
if errorlevel 1 exit /b 1
"%~1\bin\qmake.exe" main.pro
if errorlevel 1 goto fail
nmake
if errorlevel 1 goto fail
popd
copy /y "%~dp0..\bin\win-x86_64\bin\jqt.exe" "%~dp0..\bin\win-x86_64\release\jqt.exe" >nul
exit /b %errorlevel%
:fail
popd
exit /b 1
