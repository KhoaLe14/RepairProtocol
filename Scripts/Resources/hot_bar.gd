extends Inventory
class_name HotBar

static var hands:int = 5
static var heavy_item:Item = null
static var active_item:Item:
	set(val):
		if val == null:
			active_name = "none"
			return
		active_item = val
		active_name = active_item.item_name
		active_idx = Inventory.slots.find(active_item)
static var active_name:StringName
static var active_idx:int = -1
static var active_slot:int = -1
#static var heavy_item:HItem

static func select_item(idx:int):
	if idx > hands: return
	if idx >= 0 && idx != active_idx:
		active_idx = idx
		active_item = slots[idx]
		return
	active_item = null
	if idx == active_idx:
		active_idx = -1
		return
	active_idx = idx
