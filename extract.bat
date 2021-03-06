@ECHO OFF
SETLOCAL enabledelayedexpansion
CALL setenv.bat || GOTO :FAIL

if [%2] == [] if not [%3] == [] goto :USAGE

set ROOT=%2
set DOMAIN=%3
if [%ROOT%] == [] set ROOT=%DEFAULT_ROOT%
if [%DOMAIN%] == [] set DOMAIN=%DEFAULT_DOMAIN%

IF NOT EXIST "%EXTRACT_FOLDER%\%DOMAIN%" MKDIR "%EXTRACT_FOLDER%\%DOMAIN%"
del /F /Q /A "%EXTRACT_FOLDER%\%DOMAIN%"

if [%1] == [append_details] if [%DOMAIN%] == [AAD] goto :USAGE

if [%1] == [refresh]          (call :EXTRACT_ALL      && GOTO :SUCCESS)
if [%1] == [refresh_measures] (call :EXTRACT_MEASURES && GOTO :SUCCESS)
if [%1] == [install]          (call :EXTRACT_ALL      && GOTO :SUCCESS)
if [%1] == [append_details]   (call :EXTRACT_DETAILS  && GOTO :SUCCESS)
if [%1] == [replace_details]  (call :EXTRACT_DETAILS  && GOTO :SUCCESS)

if [%ERRORLEVEL%] == [1] GOTO :FAIL

:USAGE
echo This command should be called from the run.bat command
echo Usage is
echo extract refresh^|install
echo extract refresh^|install ROOT DOMAIN
echo     To make a full extraction for a refresh or an install
echo     if ROOT and DOMAIN are not set then the DEFAULT_DOMAIN and DEFAULT_ROOT are applied
echo extract append_details ROOT DOMAIN
echo     To make a partial extraction in order to append engineering data
echo extract replace_details ROOT DOMAIN
echo     To make a partial extraction in order to replace engineering data
echo extract refresh_measures ROOT DOMAIN
echo     To make a partial extraction in order to refresh measures data
goto :FAIL


:EXTRACT_ALL
call :EXTRACT_MEASURES || EXIT /b 1
call :EXTRACT_DETAILS  || EXIT /b 1
goto :EOF

:EXTRACT_MEASURES
call :extract datamart/dim-snapshots                        DIM_SNAPSHOTS                       || EXIT /b 1
call :extract datamart/dim-rules                            DIM_RULES                           || EXIT /b 1
call :extract "datamart/dim-quality-standards?tags=%QSTAGS%"  DIM_QUALITY_STANDARDS             || EXIT /b 1
call :extract datamart/dim-applications                     DIM_APPLICATIONS                    || EXIT /b 1
call :extract datamart/app-violations-measures              APP_VIOLATIONS_MEASURES             || EXIT /b 1
call :extract datamart/app-sizing-measures                  APP_SIZING_MEASURES                 || EXIT /b 1
call :extract datamart/app-functional-sizing-measures       APP_FUNCTIONAL_SIZING_MEASURES      || EXIT /b 1
call :extract datamart/app-health-measures                  APP_HEALTH_MEASURES                 || EXIT /b 1
call :extract datamart/app-sizing-evolution                 APP_SIZING_EVOLUTION                || EXIT /b 1
call :extract datamart/app-functional-sizing-evolution      APP_FUNCTIONAL_SIZING_EVOLUTION     || EXIT /b 1
call :extract datamart/app-health-evolution                 APP_HEALTH_EVOLUTION                || EXIT /b 1
call :extract datamart/mod-violations-measures              MOD_VIOLATIONS_MEASURES             || EXIT /b 1
call :extract datamart/mod-sizing-measures                  MOD_SIZING_MEASURES                 || EXIT /b 1
call :extract datamart/mod-health-measures                  MOD_HEALTH_MEASURES                 || EXIT /b 1
call :extract datamart/mod-sizing-evolution                 MOD_SIZING_EVOLUTION                || EXIT /b 1
call :extract datamart/mod-health-evolution                 MOD_HEALTH_EVOLUTION                || EXIT /b 1
goto :EOF

:EXTRACT_DETAILS
call :extract datamart/src-objects                          SRC_OBJECTS                         || EXIT /b 1
call :extract datamart/src-transactions                     SRC_TRANSACTIONS                    || EXIT /b 1
call :extract datamart/src-mod-objects                      SRC_MOD_OBJECTS                     || EXIT /b 1
call :extract datamart/src-trx-objects                      SRC_TRX_OBJECTS                     || EXIT /b 1
call :extract datamart/src-health-impacts                   SRC_HEALTH_IMPACTS                  || EXIT /b 1
call :extract datamart/src-violations                       SRC_VIOLATIONS                      || EXIT /b 1
call :extract datamart/usr-exclusions                       USR_EXCLUSIONS                      || EXIT /b 1
call :extract datamart/usr-action-plan                      USR_ACTION_PLAN                     || EXIT /b 1
GOTO :EOF

:FAIL
ECHO == Extract Failed ==
EXIT /b 1

:SUCCESS
ECHO == Extract Done ==
EXIT /b 0

:extract
ECHO.
ECHO ------------------------------
ECHO Extract %EXTRACT_FOLDER%\%DOMAIN%\%~2.csv
ECHO ------------------------------
call utilities\curl-bat text/csv "%ROOT%/%DOMAIN%/%~1" "%EXTRACT_FOLDER%\%DOMAIN%\%~2.csv"
GOTO :EOF
