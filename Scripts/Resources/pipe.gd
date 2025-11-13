extends Resource
class_name Pipes

const left = 1<<3
#const top_left = 1<<6
const top = 1<<2
#const top_right = 1<<4
const right = 1<<1
#const bottom_right = 1<<2
const bottom = 1<<0
#const bottom_left = 1<<0

#static var pipe_dir:Array[int] = [left, right, top, bottom, top_left, top_right, bottom_left, bottom_right]
static var pipe_dir:Array[int] = [left, top, right, bottom]

static var pipe_rot: Dictionary[int, int] = {
	left:180,
	top:-90,
	right:0,
	bottom:90,
	#top_left:-90,
	#top_right:0,
	#bottom_right: 90,
	#bottom_left: 180
}

static var pipe_string: Dictionary[int, String] = {
	left:"left",
	top:"top",
	right:"right",
	bottom:"bottom",
	#top_left:"top_left",
	#top_right:"top_right",
	#bottom_right:"bottom_right",
	#bottom_left:"bottom_left"
}

static var pipe_pos:Dictionary[int, Vector2] = {
	#top_left:Vector2(-1, -1),
	top:Vector2(-1, 0),
	#top_right:Vector2(-1, 1),
	left:Vector2(0, -1),
	right:Vector2(0, 1),
	#bottom_left:Vector2(1, -1),
	bottom:Vector2(1, 0),
	#bottom_right:Vector2(1, 1)
}

static var pipe_type: Dictionary[int, bool] = {
	left:true,
	top:true,
	right:true,
	bottom:true,
	#top_left:false,
	#top_right:false,
	#bottom_right: false,
	#bottom_left: false
}

var dir:int:
	set(val): if !lock: dir = val
var powered:bool = false
var lock:bool = false

func power_up(_pipe:Pipes):
	pass

static func generate_pipe(_dir:int = 0) -> Pipes:
	var pip:= Pipes.new()
	pip.dir = _dir
	return pip

func pipe_rotate():
	dir = BitKit.bit_shift(dir, true, 1, 4)
	#print(get_string_dir())

func is_pipe_connected(pos:int, pip:Pipes) -> bool:
	#print("Pos: %s, Pipe pos: %s, Connect pipe pos: %s, Connect dir: %s"%[pos, get_string_dir(), pip.get_string_dir(), pipe_string[BitKit.bit_shift(pos, true, 4, 8)]])
	return (dir & pos) && (pip.dir & BitKit.bit_shift(pos, true, 2, 4))

func form_connection(cell:int):
	dir |= cell
	powered = true
	#pip.dir |= BitKit.bit_shift(cell, true, 4, 8)
	#pip.powered = true

func has_cross() -> bool:
	return dir | left | top | right | bottom

#func has_diagon() -> bool:
	#return dir | top_left | top_right | bottom_right | bottom_left

static func includes_cross(_dir) -> bool:
	return _dir | Pipes.left | Pipes.top | Pipes.right | Pipes.bottom

#static func includes_diagon(_dir) -> bool:
	#return _dir | Pipes.top_left | Pipes.top_right | Pipes.bottom_right | Pipes.bottom_left

#func readjust(_dir:int):
	#if includes_cross(_dir):
		#while !(dir & _dir):
			#pipe_rotate()
	#elif includes_diagon(_dir):
		#while !(dir & _dir):
			#pipe_rotate()
	#else: return

func get_string_dir() -> Array[String]:
	var arr:Array[String] = []
	for i in pipe_dir:
		if dir & i: arr.append(pipe_string[i])
	return arr
