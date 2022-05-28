/*Get Trigger facts will only work on SQL Server/AzureSQL
  --Dave Babler 2022-03-23*/

SELECT  trg.name AS "TriggerName"
      , SCHEMA_NAME(tab.schema_id) + '.' + tab.name AS "TriggerHoldingTable"
      , CASE
             WHEN is_instead_of_trigger = 1 THEN
                 'Instead of'
             ELSE
                 'After'
        END AS "TimingofTrigger"
      , (CASE
              WHEN OBJECTPROPERTY(trg.object_id, 'ExecIsUpdateTrigger') = 1 THEN
                  'Update '
              ELSE
                  ''
         END + CASE
                    WHEN OBJECTPROPERTY(trg.object_id, 'ExecIsDeleteTrigger') = 1 THEN
                        'Delete '
                    ELSE
                        ''
               END + CASE
                          WHEN OBJECTPROPERTY(trg.object_id, 'ExecIsInsertTrigger') = 1 THEN
                              'Insert'
                          ELSE
                              ''
                     END
        ) AS "EventActivityOfTrigger"
      , CASE
             WHEN trg.parent_class = 1 THEN
                 'Table trigger'
             WHEN trg.parent_class = 0 THEN
                 'Database trigger'
        END AS "IsTriggerDBorTable"
      , CASE
             WHEN trg.[type] = 'TA' THEN
                 'Assembly (CLR) trigger'
             WHEN trg.[type] = 'TR' THEN
                 'SQL trigger'
             ELSE
                 ''
        END AS "IsTriggerAssemblyCLRorSQL"
      , CASE
             WHEN is_disabled = 1 THEN
                 'Disabled'
             ELSE
                 'Active'
        END AS "IsTriggerActive"
      , OBJECT_DEFINITION(trg.object_id) AS "definition"
FROM    sys.triggers trg
    LEFT JOIN
    sys.objects tab
      ON trg.parent_id = tab.object_id
ORDER BY trg.name;

