@ECHO OFF
::--------------------------------------------------------------------
:: This script performs .NET optimization and native image generation
::-------------------------------------------------------------------

ECHO Queuing .NET x86 optimization
C:\Windows\Microsoft.Net\Framework\v4.0.30319\ngen.exe update /queue
ECHO Queuing .NET x64 optimization
C:\Windows\Microsoft.Net\Framework64\v4.0.30319\ngen.exe update /queue

ECHO Running .NET x86 optimization
C:\Windows\Microsoft.Net\Framework\v4.0.30319\ngen.exe executequeueditems / silent > NUL
ECHO .NET x86 optimization completed with code: %ERRORLEVEL%

ECHO Running .NET x64 optimization
C:\Windows\Microsoft.Net\Framework64\v4.0.30319\ngen.exe executequeueditems /silent > NUL
ECHO .NET x64 optimization completed with code: %ERRORLEVEL%

EXIT /B 0