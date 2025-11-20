extends Resource
class_name Item

var item_name:StringName
var stackable:bool = false
var max_stack:int = 1:
	set(val): max_stack = val if stackable else 1
var quantity:int = 1:
	set(val): quantity = clampi(val, 0, max_stack)

var manifest_path:StringName = ""

func _init(_item_name:StringName = "", _stackable:bool = false, _max_stack:int = 1, _quantity:int = 1) -> void:
	item_name = _item_name
	stackable = _stackable
	if stackable:
		max_stack = _max_stack
		quantity = _quantity
