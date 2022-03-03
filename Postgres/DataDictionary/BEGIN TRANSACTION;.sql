BEGIN TRANSACTION;

--TCL
/*simplistic DDL*/
CREATE TABLE ShowDDLDMLDQL( Id INT , Message VARCHAR(64));

/*prove table exists in Data Dictionary (DQL)*/
SELECT *
FROM information_schema.TABLES
WHERE TABLE_NAME ILIKE '%ShowDDLDMLDQL%';


INSERT INTO ShowDDLDMLDQL( Id , Message )
VALUES( 1 ,
        'Look I exist, but I will not after the rb');


SELECT sd.Id ,
       sd.Message
FROM ShowDDLDMLDQL sd;


ROLLBACK;

/*prove table is gone after ROLLBACK in Data Dictionary (DQL)*/
SELECT *
FROM information_schema.TABLES
WHERE TABLE_NAME ILIKE '%ShowDDLDMLDQL%';



