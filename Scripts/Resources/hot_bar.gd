extends Inventory
class_name HotBar

static var hands:int = 5
static var heavy_item:Item = null
static var active_item:Item:
	set(val):
		active_item = val
		Watcher.hand_swapped.emit(val)
		print("swapped")
static var active_name:StringName
static var active_idx:int = -1
static var active_slot:int = -1
#static var heavy_item:HItem

static func select_item(idx:int):
	if idx > hands: return
	if idx >= 0 && idx != active_idx && slots[idx].item_name != "":
		active_idx = idx
		active_item = slots[idx]
		active_name = active_item.item_name
		return
	#if idx == active_idx || slots[idx].item_name == "":
	hand()
	return

static func hand():
	active_item = null
	active_name = ""
	active_idx = -1

static func carry(_item:Item):
	active_item = null
	heavy_item = _item
	active_name = heavy_item.item_name
	active_idx = -2
