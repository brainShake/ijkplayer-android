@echo off
setlocal
cd /d "%~dp0"

if not defined JAVA_HOME (
    if exist "%USERPROFILE%\.jdks\ms-17.0.19" set "JAVA_HOME=%USERPROFILE%\.jdks\ms-17.0.19"
    if exist "%USERPROFILE%\.jdks\ms-11.0.31" set "JAVA_HOME=%USERPROFILE%\.jdks\ms-11.0.31"
)
if defined JAVA_HOME set "PATH=%JAVA_HOME%\bin;%PATH%"

if not exist "prebuilt\ffmpeg\arm64\libijkffmpeg.so" (
    echo ERROR: Missing prebuilt\ffmpeg\arm64\libijkffmpeg.so
    echo Run: powershell -File tools\sync-ffmpeg-prebuilt.ps1 -SourceRoot ^<path-to-ffmpeg-build^>
    exit /b 1
)

echo [1/2] Gradle assemble release APKs...
call gradlew.bat clean assembleAll64Release assembleAll32Release --no-daemon
if errorlevel 1 exit /b 1

echo.
echo BUILD OK:
dir /s /b ijkplayer-example\build\outputs\apk\*\release\*.apk 2>nul
endlocal
