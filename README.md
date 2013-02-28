# Real Time Scheduler

##RESTful API

```terminal
curl -H "Accept: application/json" http://raytiley-msse-static-scheduler.herokuapp.com/task_sets/13/schedule
```
Will produce:

```json
{
	"tasks":
		[{ "id":50,
		  "name":"T1",
		  "period":5,
		  "worst_case_execution_time":2,
		  "offset":0,
		  "deadline":5,
		  "task_set_id":13
		}],
	"task_set":
		{ 
			"id":13,
			"name":"Simple",
			"schedule_ids":[50,50,0,0,0],
			"task_ids":[50]
		}
}
```
