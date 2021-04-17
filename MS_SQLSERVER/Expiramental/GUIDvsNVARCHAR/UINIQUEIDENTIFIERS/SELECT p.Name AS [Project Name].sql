SELECT p.Name AS [Project Name]
	, p.DueDate AS [Project Due Date]
	, CASE 
		WHEN p.DueDate > CONVERT(DATE, GETDATE())
			THEN 'Incomplete'
		ELSE 'Completed'
		END AS [Completion Status]
	, CASE 
		WHEN p.DueDate > CONVERT(DATE, GETDATE())
			THEN DATEDIFF(day, CONVERT(DATE, GETDATE()), CONVERT(DATE, p.DueDate))
		ELSE NULL
		END AS [Remaining Days]
FROM Project p
ORDER BY p.Name;

