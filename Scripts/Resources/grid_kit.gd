extends Resource
class_name GridKit
#Supports array[] and grid[cols][rows] interaction

static func return_col(rows:int, idx:int) -> int:
	var cur_row:int = 0
	while cur_row*rows < idx:
		cur_row += 1
	return idx+cur_row*rows

static func get_neighbor(cols:int, rows:int, idx:int) -> Array[int]:
	var arr:Array[int] = []
	var cur_col:int = idx % cols
	var cur_row:int = idx / cols
	for i in [-1, 0, 1]:
		var nrow:int = cur_row + i
		if nrow < 0 || nrow > rows-1: continue
		for j in [-1, 0, 1]:
			if i == 0 && j == 0: continue
			var ncol:int = cur_col + j
			if ncol < 0 || ncol > cols-1: continue
			arr.append(nrow*cols+ncol)
	return arr

static func get_coordinate_neighbor(cols:int, rows:int, idx:int) -> Dictionary[String, int]:
	var neg:Dictionary[String, int] = {}
	var pos:Dictionary[Vector2, String] = {
		Vector2(-1, -1) : "top_left",
		Vector2(-1, 0) : "top",
		Vector2(-1, 1) : "top_right",
		Vector2(0, -1) : "left",
		Vector2(0, 1) : "right",
		Vector2(1, -1) : "bottom_left",
		Vector2(1, 0) : "bottom",
		Vector2(1, 1) : "bottom_right"
	}
	var cur_col:int = idx % cols
	var cur_row:int = idx / cols
	for i in [-1, 0, 1]:
		var nrow:int = cur_row + i
		if nrow < 0 || nrow > rows-1: continue
		for j in [-1, 0, 1]:
			if i == 0 && j == 0: continue
			var ncol:int = cur_col + j
			if ncol < 0 || ncol > cols-1: continue
			neg.get_or_add(pos[Vector2(i, j)], nrow*cols+ncol)
	return neg

static func get_neighbor_idx(rows:int, cols:int, idx:int, pos:Vector2) -> int:
	var cur_row:int = idx/rows
	var cur_col:int = idx%cols
	var neg_row:int = cur_row + pos.x
	var neg_col:int = cur_col + pos.y
	if neg_col < 0 || neg_col > cols-1 || neg_row < 0 || neg_row > rows-1: return -1
	return neg_col+neg_row*cols

static func get_coordinate(cols:int, rows:int, arr:Array, arr_element:Variant) -> Vector2:
	var idx:int = arr.find(arr_element)
	if idx == -1: return Vector2(-1, -1)
	return Vector2(idx/rows, idx%cols)

static func get_coordinateidx(cols:int, rows:int, idx:int) -> Vector2:
	return Vector2(idx/rows, idx%cols)
