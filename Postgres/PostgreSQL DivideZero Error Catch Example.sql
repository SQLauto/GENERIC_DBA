SET ROLE "BUSBuild";

CREATE OR REPLACE PROCEDURE public."DivideZero"(intnumerator integer)
 LANGUAGE plpgsql
AS $procedure$
/*
    Created By:     Dave Babler
    Created On:     2022-01-11
    SubProcedures:  none
    Description:    Divides by zero to throw an error
                    
*/
DECLARE
    intDenominator INT;
    strProc VARCHAR(64); --NAME OF PROC
    strErrContext VARCHAR(2000); -- NEED FOR exception
    txtExcContextRaw text; -- NEED FOR exception
BEGIN
    intDenominator := 0;
    strProc  := 'public."DivideZero"';
    SELECT intNumerator/intDenominator;

   EXCEPTION WHEN OTHERS THEN 
    GET STACKED DIAGNOSTICS txtExcContextRaw =PG_EXCEPTION_CONTEXT ;
    strErrContext := LEFT(CAST(txtExcContextRaw  AS varchar), 2000) ; --HAVE TO DO THIS FOR THE TABLE
        INSERT INTO err.db_exception_tank(DatabaseName, UserName, UserIP, UserPID, ErrorProcedure, ErrorState, ErrorMessage, ErrorContext)
        VALUES(current_database(), current_user, inet_client_addr(), pg_backend_pid(), strProc, SQLSTATE, SQLERRM, strErrContext);
    RAISE NOTICE 'ERROR: check exception tank';    
/*TESTING SCRIPT IS BELOW*/
/*
    CALL "DivideZero"(8);
*/
END;
$procedure$
;

RESET ROLE;