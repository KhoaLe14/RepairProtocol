@tool
extends EditorScript

const LEFT = 8
const TOP = 4
const RIGHT = 2
const BOTTOM = 1

func _run() -> void:
	print(MathKit.stretch(0.6, 2))
	var meh: AnimationNodeBlendTree
