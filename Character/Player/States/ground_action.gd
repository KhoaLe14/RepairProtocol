extends GroundState

func _enter() -> void:
	super()
	#var duration:float = 1
	#await assign_duration(duration)
	#print(duration)
	#add_child(TimerKit.generate_timer(duration, func():
		#character.hit = false
		#dispatch_default()))

func assign_duration(dur:float) -> float:
	if limbo.tool_hit: dur = AniTimes.time_from_name[limbo.tool_action]
	elif limbo.interact: dur = AniTimes.time_from_name[limbo.interact_action]
	return 1
