@abstract
extends LimboState
class_name CharacterState

@export var ani_kit:AniKit
var limbo:LimboHSM
var ani:AnimationPlayer
var use_default_ani:bool = true

func _setup() -> void:
	limbo = get_parent()
	ani = limbo.character.ani

func _enter() -> void:
	if use_default_ani: ani_kit.play(ani)
