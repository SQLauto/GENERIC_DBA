SELECT  TABLE_NAME
      , COLUMN_NAME
FROM    INFORMATION_SCHEMA.COLUMNS
WHERE   TABLE_NAME NOT IN
        (
            SELECT  TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
        )
        AND
        (
            COLUMN_NAME LIKE '%name%'
            OR  COLUMN_NAME LIKE '%first%'
            OR  COLUMN_NAME LIKE '%last%'
            OR  COLUMN_NAME LIKE '%ssn%'
            OR  COLUMN_NAME LIKE '%soc%'
            OR  COLUMN_NAME LIKE '%bank%'
            OR  COLUMN_NAME LIKE '%birt%'
            OR  COLUMN_NAME LIKE '%dob%'
            OR  COLUMN_NAME LIKE '%acc%'
            OR  COLUMN_NAME LIKE '%phon%'
        )
        AND COLUMN_NAME NOT LIKE '%modif%'
        AND COLUMN_NAME NOT LIKE '%activity%'
        AND COLUMN_NAME NOT LIKE '%referenceddate%'
ORDER BY TABLE_NAME;

