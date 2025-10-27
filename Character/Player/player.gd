extends Character
class_name Player

@export var limbo:LimboHSM

func _ready() -> void:
	limbo.set_active(true)
