@ECHO OFF
SETLOCAL enabledelayedexpansion
CALL setenv.bat || GOTO :FAIL

del /F /Q /A "%EXTRACT_FOLDER%"



call :extract datamart/dim-snapshots                        DIM_SNAPSHOTS                       || GOTO :FAIL
call :extract datamart/dim-rules                            DIM_RULES                           || GOTO :FAIL
call :extract "datamart/dim-quality-standards?tags=%QSTAGS%"  DIM_QUALITY_STANDARDS             || GOTO :FAIL
call :extract datamart/dim-applications                     DIM_APPLICATIONS                    || GOTO :FAIL
call :extract datamart/app-violations-measures              APP_VIOLATIONS_MEASURES             || GOTO :FAIL
call :extract datamart/app-sizing-measures                  APP_SIZING_MEASURES                 || GOTO :FAIL
call :extract datamart/app-functional-sizing-measures       APP_FUNCTIONAL_SIZING_MEASURES      || GOTO :FAIL
call :extract datamart/app-health-measures                  APP_HEALTH_MEASURES                 || GOTO :FAIL
call :extract datamart/app-sizing-evolution                 APP_SIZING_EVOLUTION                || GOTO :FAIL
call :extract datamart/app-functional-sizing-evolution      APP_FUNCTIONAL_SIZING_EVOLUTION     || GOTO :FAIL
call :extract datamart/app-health-evolution                 APP_HEALTH_EVOLUTION                || GOTO :FAIL
call :extract datamart/mod-violations-measures              MOD_VIOLATIONS_MEASURES             || GOTO :FAIL
call :extract datamart/mod-sizing-measures                  MOD_SIZING_MEASURES                 || GOTO :FAIL
call :extract datamart/mod-health-measures                  MOD_HEALTH_MEASURES                 || GOTO :FAIL
call :extract datamart/mod-sizing-evolution                 MOD_SIZING_EVOLUTION                || GOTO :FAIL
call :extract datamart/mod-health-evolution                 MOD_HEALTH_EVOLUTION                || GOTO :FAIL

GOTO :SUCCESS

:FAIL
ECHO == Extract Failed ==
EXIT /b 1

:SUCCESS
ECHO == Extract Done ==
EXIT /b 0

:extract
ECHO.
ECHO ------------------------------
ECHO Extract %~2
ECHO ------------------------------
curl --no-buffer -f -k -H "Accept: text/csv"  -u %CREDENTIALS% "%ROOT%/%~1" -o "%EXTRACT_FOLDER%\%~2.csv" || EXIT /b 1
GOTO :EOF
