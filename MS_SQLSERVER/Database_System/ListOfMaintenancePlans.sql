SELECT  mp.name AS "MaintenancePlan"
      , mp.[description] AS "Description"
      , mp.[owner] AS "Owner"
      , sp.subplan_name AS "Subplan"
      , sp.subplan_description AS "SubplanDescription"
      , sj.name AS "Job"
      , sj.[description] AS "JobDescription"
      , sj.[enabled] AS "IsEnabled"
FROM    msdb..sysmaintplan_plans mp
    INNER JOIN
    msdb..sysmaintplan_subplans sp
       ON mp.id = sp.plan_id
    INNER JOIN
    msdb..sysjobs sj
       ON sp.job_id = sj.job_id;
