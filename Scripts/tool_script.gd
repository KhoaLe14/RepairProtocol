@tool
extends EditorScript

const LEFT = 8
const TOP = 4
const RIGHT = 2
const BOTTOM = 1

func _run() -> void:
	var ship:Vehicle = Vehicle.new()
	print(ship.tasks)
