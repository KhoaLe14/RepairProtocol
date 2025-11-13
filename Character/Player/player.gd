extends Character
class_name Player

var dir:Vector3
var input_dir:Vector2 = Vector2.ZERO
@export var fps_cam:FPSCam
@export var look_ray:RayCast3D
@export var pointer_label:Label
var cd:bool = false
var hit:bool = false
#var og_player:Array[Vector3] = []
#var op_cam:Array[Vector3] = []
@export var neck:Node3D
@onready var arm_ik: SkeletonIK3D = $RepairEmployeeVer2/rig_001/Skeleton3D/armIK
@onready var holding_bone: BoneAttachment3D = $RepairEmployeeVer2/rig_001/Skeleton3D/BoneAttachment3D
@onready var carry_marker: Marker3D = $Neck/CarryMarker
@onready var arm_marker: Marker3D = $Neck/FPSCam/ArmMarker


func _ready() -> void:
	super()
	Watcher.player = self
	Watcher.carry = carry_marker
	Watcher.right_hand = $RepairEmployeeVer2/rig_001/Skeleton3D/BoneAttachment3D
	#Watcher.action_ended.connect(func(): hit = false)
	#rot_offset = rotation - fps_cam.rotation
	#pos_offset = position - fps_cam.position
	#transform_offset = transform - fps_cam.transform
	limbo_player.set_active(true)
	(limbo_player as LimboHSM).blackboard.bind_var_to_property(BBNames.direction, self, "dir")
	#og_player = [position, rotation]
	#op_cam = [fps_cam.position, fps_cam.rotation]
	#$AnimationTree.sta

func _process(delta: float) -> void:
	fps_cam.process_mode = ReferKit.flow(GState.game_state, [GState.gstate_enum.INSPECTING, GState.gstate_enum.PLAYING], [Node.PROCESS_MODE_DISABLED, Node.PROCESS_MODE_INHERIT])
	global_rotation.y = neck.global_rotation.y
	$AnimationTree.set("parameters/Movement/blend_position", input_dir)
	#print(neck.global_position)

func _physics_process(delta: float) -> void:
	display_pointer()
	movement_input()
	dir = velocity.normalized()
	limbo_player.update(delta)
	move_and_slide()
	#print("Player: pos: %s  rot: %s"%[position-og_player[0], rotation-og_player[1]])
	#print("Cam: pos: %s  rot: %s"%[fps_cam.position - op_cam[0], fps_cam.rotation - op_cam[1]])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") && GState.is_inspecting():
		fps_cam.current = true
		GState.play()
	if event.is_action_pressed("interact") && display_pointer():
		var ia:InteractArea = look_ray.get_collider()
		ia.interacted.emit()
	if event.is_action_pressed("mouse1") && GState.is_playing():
		hit = true
	if event.is_action_released("mouse1") && GState.is_playing():
		hit = false

func movement_input():
	if !GState.is_playing():
		input_dir = Vector2.ZERO
		return
	if Input.is_action_just_pressed("ui_left"): input_dir.x -= 1
	if Input.is_action_just_pressed("ui_right"): input_dir.x += 1
	if Input.is_action_just_pressed("ui_up"): input_dir.y += 1
	if Input.is_action_just_pressed("ui_down"): input_dir.y -= 1
	
	if Input.is_action_just_released("ui_left"): input_dir.x += 1
	if Input.is_action_just_released("ui_right"): input_dir.x -= 1
	if Input.is_action_just_released("ui_up"): input_dir.y -= 1
	if Input.is_action_just_released("ui_down"): input_dir.y += 1
	
	var move_dir = (fps_cam.get_forward() * input_dir.y + fps_cam.get_right() * input_dir.x).normalized()
	#print(move_dir)
	velocity = Vector3(move_dir.x, 0, move_dir.z)*stat.speed
	#if InputKit.press(Input, "ui_left"): pass

func display_pointer() -> bool:
	if look_ray.is_colliding() && look_ray.get_collider() != null && GState.is_playing():
		pointer_label.text = look_ray.get_collider().par.name
		return true
	else: pointer_label.text = ""
	return false

func display_cd():
	cd = true
	add_child(TimerKit.generate_timer(0.1, func(): cd = false))

func hand_snap(_transform:Transform3D):
	#arm_ik.influence = 1
	arm_ik.stop()
	arm_ik.target_node = ""
	arm_ik.target = _transform
	arm_ik.start(true)

func hand_snap_back():
	#arm_ik.stop()
	#arm_ik.influence = 0.5
	arm_ik.target_node = arm_marker.get_path()
	arm_ik.start()
