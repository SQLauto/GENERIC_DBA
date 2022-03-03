SELECT DISTINCT e.name AS EventName
FROM fn_trace_geteventinfo(1) evi
INNER JOIN sys.trace_events e
	ON evi.eventid = e.trace_event_id
