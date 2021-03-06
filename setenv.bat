REM ------------------------------------------------------------------------------
REM ------
REM ------ CONFIGURE THE FOLLOWING SETTINGS
REM ------
REM ------------------------------------------------------------------------------

REM SET THE ROOT FOLDER OF THE ETL
REM MAKE SURE TO NOT INCLUDE "\" AT THE END OF THE PATH
REM DO NOT SET DOUBLE-QUOTES
SET INSTALLATION_FOLDER=C:\datamart

REM CHANGE THE POSTGRESQL PATHS 
REM DO NOT SET DOUBLE-QUOTES
SET PSQL=C:\Program Files\CAST\CASTStorageService3\bin\psql.exe
SET VACUUMDB=C:\Program Files\CAST\CASTStorageService3\bin\vacuumdb.exe
 
REM IN CASE OF A SINGLE DOMAIN EXTRACTION, YOU CAN SUPPLY A DEFAULT URL AND DOMAIN FOR THE RUN.BAT COMMAND
REM THE DATAMART.BAT COMMAND IGNORES THESE DEFAULT SETTINGS
REM MAKE SURE TO NOT INCLUDE "/" AT THE END OF URL
REM EXAMPLE: 
SET DEFAULT_ROOT=http://localhost:9090/CAST-RESTAPI/rest
SET DEFAULT_DOMAIN=AAD

REM SET THE QUALITY STANDARDS TAGS TO EXTRACT IN CASE OF A HEALTH DOMAIN EXTRACTION
SET QSTAGS=AIP-TOP-PRIORITY,CWE,OMG-ASCQM-Security,OWASP-2017

REM SET TARGET DATABASE
SET _DB_HOST=localhost
SET _DB_PORT=2282
SET _DB_NAME=reporting
SET _DB_USER=
SET _DB_SCHEMA=datamart

REM ------------------------------------------------------------------------------
REM ------
REM ------ DO NOT CHANGE ANYTHING BELOW THIS LINE 
REM ------
REM ------------------------------------------------------------------------------

IF NOT DEFINED INSTALLATION_FOLDER (echo Missing variable INSTALLATION_FOLDER & EXIT /b 1)
IF NOT DEFINED DEFAULT_DOMAIN (echo Missing variable DEFAULT_DOMAIN & EXIT /b 1)
IF NOT DEFINED PSQL (echo Missing variable PSQL & EXIT /b 1)
IF NOT DEFINED VACUUMDB (echo Missing variable VACUUMDB & EXIT /b 1)
IF NOT DEFINED DEFAULT_ROOT (echo Missing variable DEFAULT_ROOT & EXIT /b 1)
IF NOT DEFINED _DB_HOST (echo Missing variable _DB_HOST & EXIT /b 1)
IF NOT DEFINED _DB_PORT (echo Missing variable _DB_PORT & EXIT /b 1)
IF NOT DEFINED _DB_NAME (echo Missing variable _DB_NAME & EXIT /b 1)
IF NOT DEFINED _DB_USER (echo Missing variable _DB_USER & EXIT /b 1)
IF NOT DEFINED _DB_SCHEMA (echo Missing variable _DB_SCHEMA & EXIT /b 1)

SET EXTRACT_FOLDER=%INSTALLATION_FOLDER%\extract
SET TRANSFORM_FOLDER=%INSTALLATION_FOLDER%\transform
SET VIEWS_FOLDER=%INSTALLATION_FOLDER%\views
SET LOG_FILE=%INSTALLATION_FOLDER%\ETL.log

SET PSQL_OPTIONS=-d %_DB_NAME% -h %_DB_HOST% -U %_DB_USER% -p %_DB_PORT% --set=ON_ERROR_STOP=true
SET VACUUM_OPTIONS=-h %_DB_HOST% -U %_DB_USER% -p %_DB_PORT%

