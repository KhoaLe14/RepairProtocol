extends Resource
class_name Task

var task_name:StringName = ""
var status:bool = false
var task_level:int = 0
var sub_tasks:Array[Task] = []:
	set(val):
		sub_tasks = val.filter(func(x): return x.task_level > task_level)
		status_check()

func status_check():
	status = sub_tasks.all(func(x): return x.status)

func tick(): status = true
func untick(): status = false
