# Real Time Scheduler

##RESTful API

There are two primary endpoints for working with the scheduling api, `/task_sets` and `/tasks`. 

*`/task_sets` supports create and read opperations. 
*`/tasks` supports standard CRUD opperations. 

Additionally `/task_sets` has two additional endpoints, `/task_sets/:id/schedule` and `task_sets/:id/verify`. 

*`/task_sets/:id/schedule` supports only GET opperations and returns an array of task ids that represents the schedule.
*`\task_sets\:id\verify` supports only POST operations and accepts an array of task ids that make up the schedule. 

A valid schedule will return a `200 OK` response code. An invalid schedule will return a `406 Not Acceptable` response code. Further details about all the end points are provided below.

### Working with Task Sets
Getting all tasks can be done by making a call on the `/task_sets` endpoint.

```
curl -H "Accept: application/json" http://raytiley-msse-static-scheduler.herokuapp.com/task_sets/
```

Which will produce something like the following

```json
{
	"tasks":
		[{
			"id":74,
			"name":"T1",
			"period":5,
			"worst_case_execution_time":2,
			"offset":0,
			"deadline":5,
			"task_set_id":15
		},{
			"id":75,
			"name":"T1",
			"period":10,
			"worst_case_execution_time":2,
			"offset":0,
			"deadline":10,
			"task_set_id":16
		},{
			"id":76,
			"name":"T2",
			"period":5,
			"worst_case_execution_time":1,
			"offset":0,
			"deadline":5,
			"task_set_id":16
		}],
	"task_sets":
		[{
			"id":15,
			"name":"simple",
			"schedule_ids":[74,74,0,0,0],
			"task_ids":[74]
		},{
			"id":16,
			"name":"second",
			"schedule_ids":[76,75,75,0,0,76,0,0,0,0],
			"task_ids":[75,76]
		}]
}

```

Notice that there are two root level objects. An array of task sets, and an array of tasks. The tasks sets only reference tasks by id. Each task set object also has an array of task ids in the `schedule_ids` property that represent the task sets schedule. `schedule_ids` will be null if the scheduler can not generate a valid schedule for the task set.

To request the schedule for a specific task set send a GET request to `/task_sets/:id/schedule`.

```
curl -H "Accept: application/json" http://raytiley-msse-static-scheduler.herokuapp.com/task_sets/13/schedule
```

Will produce:

```json
	{
		"schedule":[76,75,75,0,0,76,0,0,0,0]
	}
```
