extends Resource
class_name AniKit

static var p_idle:StringName = ""
static var p_walk:StringName = ""
static var p_run:StringName = ""
static var p_hold:StringName = ""

static func play(ani:AnimationPlayer, ani_name:StringName, blend:float = -1, speed:float = 1, from_end:bool = false):
	ani.play(ani_name, blend, speed, from_end)
