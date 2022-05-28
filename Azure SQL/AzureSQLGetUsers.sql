SELECT  name AS username
      , create_date
      , modify_date
      , type_desc AS type
      , authentication_type_desc AS authentication_type
FROM    sys.database_principals
WHERE   type NOT IN ( 'A', 'G', 'R', 'X' )
        AND sid IS NOT NULL
ORDER BY username;
