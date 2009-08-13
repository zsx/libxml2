@echo off
set RELEASE_PATH=%~dp0\..\Win32\Release
set MAJORMINOR=2.0
%OAH_INSTALLED_PATH%bin\pkg-config --modversion %RELEASE_PATH%\lib\pkgconfig\libxml-%MAJORMINOR%.pc > libver.tmp || goto error
set /P LIBVER= < libver.tmp
del libver.tmp

nmake /nologo version=%LIBVER% api_version=%MAJORMINOR% release_path=%RELEASE_PATH% %*

goto:eof
:error
del libver.tmp
echo Couldn't start build process... remeber to compile libxml2.sln with OAH_BUILD_OUTPUT cleared!??