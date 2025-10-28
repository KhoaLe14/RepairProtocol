extends Control

const cols:int = 5
const rows:int = 5
var cellsize:float = 120
var pipe_grid:Array #[int, int] - [rows, pipe.dir]
var pipe_grid_container:GridContainer
var pipes:Array[PipeTexture] = []
var starting_pipe: int = 1
var starting_dir:int
var int_to_dir:Dictionary = {
	-1:Pipes.top,
	0:Pipes.right,
	1:Pipes.bottom
}
var powered_img:NinePatchRect
var unpowered_img:NinePatchRect
var first_pipe_row:int = 0
var last_pipe_row:int = 0
var goal_pipe:PipeTexture

func _ready() -> void:
	
	pipe_grid_container = get_children().filter(func(x): return x is GridContainer)[0]
	pipe_grid_container.columns = cols
	#cellsize = pipe_grid_container.size.y/rows
	powered_img = $Powered_Img
	unpowered_img = $Unpowered_Img
	powered_img.custom_minimum_size = Vector2.ZERO
	unpowered_img.custom_minimum_size = Vector2.ZERO
	powered_img.size = Vector2(cellsize, cellsize)
	unpowered_img.size = Vector2(cellsize, cellsize)
	powered_img.clip_contents = true
	unpowered_img.clip_contents = true
	starting_pipe = randi_range(0, 4)
	first_pipe_row = starting_pipe
	starting_dir = ReferKit.flow(starting_pipe, [0, 4, true], [randi_range(0, 1), randi_range(-1, 0), randi_range(-1, 1)])
	pipe_grid = generate_grid()
	await generate_grid_containder()
	#pipes = pipe_grid_container.get_children().map(func(x): return x)
	#print(pipe_grid)
	await generate_solution(0, starting_pipe, true)
	await reroute(pipe_grid_container.get_children()[starting_pipe*cols])
	puzzle_shuffle()
	wipe()
	update_goal_img(cellsize)

func generate_grid() -> Array:
	var col:Array
	var map1:= func(x:Pipes): return x.dir
	var map2:= func(x:Array): return x.map(map1)
	for i in range(0, cols):
		var row:Array[Pipes]
		for j in range(0, rows):
			var random_dir:int
			while(BitKit.counts_bit(random_dir) != 2): random_dir = randi_range(1, 0b1100)
			row.append(Pipes.generate_pipe(random_dir))
		col.append(row)
	var fin_col:Array = col.map(map2)
	return fin_col

func generate_pipe_texture() -> PipeTexture:
	var pipe_text:PipeTexture = preload("res://Scenes/pipe.tscn").instantiate()
	pipe_text.pipe = Pipes.generate_pipe()
	#pipe_text.custom_minimum_size = Vector2.ZERO
	pipe_text.custom_minimum_size = Vector2(cellsize, cellsize)
	pipe_text.clip_contents = true
	pipe_text.subready()
	pipe_text.btn.pressed.connect(wipe)
	var func1:= func():
		if goal_pipe.lit_up():
			unpowered_img.texture = load("res://Images/powered.jpg") as Texture2D
			add_child(TimerKit.generate_timer(0.8, func(): queue_free()))
	pipe_text.btn.pressed.connect(func1)
	return pipe_text

func generate_grid_containder():
	for i in range(cols*rows): pipe_grid_container.add_child(generate_pipe_texture())
	for i in pipe_grid.size():
		for j in pipe_grid[i].size():
			var pipe_text = pipe_grid_container.get_child(j+i*cols)
			pipe_text.pipe.dir = pipe_grid[i][j]
			if i*cols + j == starting_pipe*rows:
				pipe_text.pipe.dir = Pipes.left + int_to_dir[starting_dir]
				pipe_text.pipe.powered = true
				pipe_text.pipe.lock = true
			pipe_text.update_display()

func puzzle_shuffle():
	for i:PipeTexture in pipe_grid_container.get_children():
		for j in range(randi_range(0,3)): i.pipe.pipe_rotate()
		i.update_display()
	#refresh()

func generate_solution(ridx:int = 0, crow:int = starting_pipe, init:bool = false, last_dir:int = Pipes.left):
	var top_idx:int = 0
	var bottom_idx:int = cols - 1
	var last_idx:int = rows - 1
	var cur_pipe:PipeTexture = (pipe_grid_container.get_children()[ridx+crow*cols] as PipeTexture)
	if !init: cur_pipe.form_and_update(last_dir)
	
	if ridx == last_idx:
		var last_pipe:PipeTexture = pipe_grid_container.get_children()[ridx+crow*cols] as PipeTexture
		last_pipe.pipe.dir = (last_pipe.get_dir() | Pipes.right)
		last_pipe.update_display()
		last_pipe_row = crow
		goal_pipe = last_pipe
		return last_pipe
	
	var next_dir:int = crow
	
	if !init:
		match(crow):
			top_idx:
				if !get_specific_neighbor(cur_pipe, Pipes.pipe_pos[Pipes.bottom]).pipe.powered: crow = [crow, crow+1].pick_random()
				else: crow = crow
			bottom_idx:
				if !get_specific_neighbor(cur_pipe, Pipes.pipe_pos[Pipes.top]).pipe.powered: crow = [crow, crow-1].pick_random()
				else: crow = crow
			_:
				crow = [crow, crow+1, crow-1].pick_random()
	if init: crow += starting_dir
	next_dir = crow - next_dir
	#var next_pipe:PipeTexture = (pipe_grid_container.get_children()[ridx+crow*cols] as PipeTexture)
	match(next_dir):
		-1:
			cur_pipe.form_and_update(Pipes.top)
			last_dir = Pipes.bottom
		0:
			cur_pipe.form_and_update(Pipes.right)
			last_dir = Pipes.left
		1:
			cur_pipe.form_and_update(Pipes.bottom)
			last_dir = Pipes.top
	generate_solution(ridx+1, crow, false, last_dir)

func wipe():
	for i:PipeTexture in pipe_grid_container.get_children():
		if !i.pipe.lock: i.pipe.powered = false
		i.update_display()
	reroute(pipe_grid_container.get_children()[starting_pipe*rows])

func get_pipe_neighbor(pip:PipeTexture) -> Array[PipeTexture]:
	var cur_idx:int = pipe_grid_container.get_children().find(pip)
	var arr:Array[int] = GridKit.get_neighbor(cols, rows, cur_idx)
	var arr2:Array[PipeTexture]
	arr2.resize(arr.size())
	for i in arr2.size(): arr2[i] = pipe_grid_container.get_children()[arr[i]]
	return arr2

func get_pipe_coordinate_neighbor(pip:PipeTexture) -> Dictionary[int, PipeTexture]:
	var cur_idx:int = pipe_grid_container.get_children().find(pip)
	var neg:Dictionary[String, int] = GridKit.get_coordinate_neighbor(cols, rows, cur_idx)
	var neg_dict:Dictionary[int, PipeTexture] = {}
	for i in neg.keys():
		neg_dict.get_or_add(Pipes.pipe_string.find_key(i), pipe_grid_container.get_children()[neg[i]])
	return neg_dict

func get_specific_neighbor(pip:PipeTexture, pos:Vector2) -> PipeTexture:
	var cur_idx:int = pipe_grid_container.get_children().find(pip)
	var neg_idx:int = GridKit.get_neighbor_idx(rows, cols, cur_idx, pos)
	return pipe_grid_container.get_children()[neg_idx]

func reroute(pip:PipeTexture):
	if !pip.pipe.powered: return
	var neg:Dictionary[int, PipeTexture] = get_pipe_coordinate_neighbor(pip)
	var connected_neg:Dictionary[int, PipeTexture]
	for i:PipeTexture in neg.values():
		var key:int = neg.find_key(i)
		if pip.is_pipe_connected(key, i) && i.pipe.powered == false: connected_neg.get_or_add(key, i)
	for i:PipeTexture in connected_neg.values():
		#var key:int = connected_neg.find_key(i)
		i.pipe.powered = true
		i.update_display()
		reroute(i)

func refresh():
	for i:PipeTexture in pipe_grid_container.get_children(): i.update_display()

func update_goal_img(cell_siz:float):
	powered_img.position += Vector2(0, cell_siz*first_pipe_row)
	unpowered_img.position += Vector2(0, cell_siz*last_pipe_row)

#func get_neighbor_pipe(pip:PipeTexture, _dir:int) -> PipeTexture:
	#var pip_idx:int = pipe_grid_container.get_children()
