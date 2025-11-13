extends Item
class_name Tool

func _init(_item_name:StringName = "", _stackable:bool = false, _max_stack:int = 1, _quantity:int = 1) -> void:
	super(_item_name, false)
