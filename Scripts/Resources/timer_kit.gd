extends Resource
class_name TimerKit

static func generate_timer(duration, funcs:Callable, oneshot = true):
	var tim:Timer = Timer.new()
	tim.timeout.connect(funcs)
	if oneshot: tim.timeout.connect(func(): tim.queue_free())
	tim.wait_time = duration
	tim.one_shot = oneshot
	tim.autostart = true
	return tim

static func echo_timer(duration:float, interval:float, funcs:Callable, node:Node):
	if duration < interval: return
	var tim = generate_timer(interval, funcs)
	node.add_child(tim)
	tim.timeout.connect(func(): echo_timer(duration - interval, interval, funcs, node))
