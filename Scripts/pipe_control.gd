extends Control
class_name PipeTexture

var pipe:Pipes
@export var btn:Button

#func _ready() -> void:
	#var func1:= func():
		#pipe.pipe_rotate()
	#btn.pressed.connect(func1)
	#add_child(TimerKit.generate_timer(1, func(): visible = !visible, false))

func subready():
	var func1:= func():
		pipe.pipe_rotate()
		update_display()
		#print("subready ran.")
	btn.pressed.connect(func1)

func update_display():
	#print(BitKit.bit_to_string(pipe.dir))
	pipe_cache()
	for i:int in Pipes.pipe_rot.keys():
		if BitKit.contains_bit(pipe.dir, i):
			dup_pipe(Pipes.pipe_type[i], i)
			#print(Pipes.pipe_string[i])
	if pipe.powered: btn.modulate = Color(0, 0, 1, 1)
	else: btn.modulate = Color(1, 1, 1, 1)

func pipe_cache():
	var arr:Array = get_children().filter(func(x): return x is NinePatchRect)
	for i in arr:
		i.queue_free()

func dup_pipe(cross:bool = true, dir:int = 0):
	var new_pipe:NinePatchRect
	if cross:
		new_pipe = preload("res://Controls/PipePuzzle/cross.tscn").instantiate()
	else:
		new_pipe = preload("res://Controls/PipePuzzle/diagon.tscn").instantiate()
	
	new_pipe.rotation = deg_to_rad(Pipes.pipe_rot[dir])
	new_pipe.visible = true
	#if pipe.powered: btn
	add_child(new_pipe)

func get_dir() -> int: return pipe.dir

#func redirect_pipe(_dir:int):
	#pipe.dir = _dir
	#update_display()

func form_and_update(_dir):
	pipe.form_connection(_dir)
	update_display()
	#pip_txt.update_display()

func is_pipe_connected(pos:int, pip:PipeTexture) -> bool:
	return pipe.is_pipe_connected(pos, pip.pipe)

func lit_up() -> bool:
	return pipe.dir & Pipes.right && pipe.powered
