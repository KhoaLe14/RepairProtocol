@tool
extends EditorScript

const LEFT = 8
const TOP = 4
const RIGHT = 2
const BOTTOM = 1

func _run() -> void:
	var a:int = 0b1000
	var b:int = 0b100
	print(a & b)
