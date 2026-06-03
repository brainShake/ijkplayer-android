@echo off
cd /d "%~dp0"
call gradlew.bat :ijkplayer-example:installAll64Debug
if errorlevel 1 exit /b 1
echo.
echo Installed all64Debug. APK should be about 30MB (not ~2MB).
echo Android Studio: Build Variant = all64Debug, disable "Apply Changes" for native code.
echo Prefer this script or "gradlew installAll64Debug" instead of a bare Run when .so are missing.
pause
