/**This gets the last date the object was modified on SQLSERVER
WARNING: INDEX reubuilds show as table changes
    Dave Babler */

DECLARE @intDatesBackToLook INT;
SET @intDatesBackToLook = 3; --you set this!

SELECT  name
      , modify_date
FROM    sys.objects
WHERE   type IN ( 'U', 'P', 'FN', 'C', 'F', 'U', 'D', 'TF', 'PK' )
        AND DATEDIFF(D, modify_date, GETDATE()) < @intDatesBackToLook;
