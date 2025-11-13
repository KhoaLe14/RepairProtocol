extends Node3D

func _process(delta: float) -> void:
	visible = HotBar.active_name == ItemNames.hammer
