extends Level

@export var player:Player

func _ready() -> void:
	var ship:Vehicle = Vehicle.new()
	print(ship.tasks)
	#snap_point1.snapped.connect(func(): GState.game_state = GState.playing)
