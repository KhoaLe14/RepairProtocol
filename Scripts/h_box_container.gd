extends HBoxContainer

func _process(delta: float) -> void:
	visible = !GState.is_solving()
	draw_hands()

func draw_hands():
	for i in HotBar.hands:
		var main_text_rect:TextureRect = (get_child(i).get_child(0) as TextureRect)
		var selected_text_rect:TextureRect = get_child(i).get_child(1)
		if Inventory.is_empty(i): main_text_rect.texture = $None.get_texture()
		else: main_text_rect.texture = load(ImgPaths.img_dict[Inventory.slots[i].item_name])
		selected_text_rect.visible = i == HotBar.active_idx
