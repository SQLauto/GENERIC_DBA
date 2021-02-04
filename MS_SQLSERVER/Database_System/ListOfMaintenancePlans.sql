/* quick details regarding any maintenance plans you've inherited */
SELECT mp.name [MaintenancePlan]
	, mp.[description] [Description]
	, mp.[owner] [Owner]
	, sp.subplan_name [Subplan]
	, sp.subplan_description [SubplanDescription]
	, sj.name [Job]
	, sj.[description] [JobDescription]
	, sj.[enabled] [IsEnabled]
FROM msdb..sysmaintplan_plans mp
INNER JOIN msdb..sysmaintplan_subplans sp
	ON mp.id = sp.plan_id
INNER JOIN msdb..sysjobs sj
	ON sp.job_id = sj.job_id
