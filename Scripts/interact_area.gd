extends Area3D
class_name InteractArea

var on_cd:bool = false
signal interacted
@onready var par:Node = get_parent()

func toggle_monitor():
	monitoring = !monitoring
	monitorable = !monitorable
