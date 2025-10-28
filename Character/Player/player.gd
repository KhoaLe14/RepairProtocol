extends Character
class_name Player

@export var ani:AnimationPlayer
var dir:Vector3

func _ready() -> void:
	limbo_player.set_active(true)
	(limbo_player as LimboHSM).blackboard.bind_var_to_property(BBNames.direction, self, "dir")

func _physics_process(delta: float) -> void:
	dir = velocity.normalized()
	limbo_player.update(delta)
