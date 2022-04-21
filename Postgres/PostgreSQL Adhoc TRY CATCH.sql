DO $$
<<first_block>>
DECLARE
    intDenominator INT;
    strProc VARCHAR(64); --NAME OF PROC
    strErrContext VARCHAR(2000); -- NEED FOR exception
    txtExcContextRaw text; -- NEED FOR exception
BEGIN
    intDenominator := 0;
    strProc  := 'ADHOC Divide By Zero Test'; --note how we changed to what we're testing 
    SELECT intNumerator/intDenominator;

   EXCEPTION WHEN OTHERS THEN 
    GET STACKED DIAGNOSTICS txtExcContextRaw =PG_EXCEPTION_CONTEXT ;
    strErrContext := LEFT(CAST(txtExcContextRaw  AS varchar), 2000) ; --HAVE TO DO THIS FOR THE TABLE
        INSERT INTO err.db_exception_tank(DatabaseName, UserName, UserIP, UserPID, ErrorProcedure, ErrorState, ErrorMessage, ErrorContext)
        VALUES(current_database(), current_user, inet_client_addr(), pg_backend_pid(), strProc, SQLSTATE, SQLERRM, strErrContext);
    RAISE NOTICE 'ERROR: check exception tank';    

END first_block $$;