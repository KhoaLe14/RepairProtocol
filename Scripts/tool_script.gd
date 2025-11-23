@tool
extends EditorScript

const LEFT = 8
const TOP = 4
const RIGHT = 2
const BOTTOM = 1

func _run() -> void:
	var ani_tree:AnimationTree = get_one_selected()
	#ani_tree.set("parameters/Others/FrontDoor2/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	ani_tree.get_tree_root()

func get_one_selected() -> Node:
	return get_editor_interface().get_selection().get_selected_nodes()[0]
