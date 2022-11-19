extends KinematicBody2D

var max_speed := 200
var position_update_rate := 0.03
var spawn_position := Vector2.ZERO

var _pos_update_time_accumulate := 0.0
var _move_input := Vector2.ZERO


func _ready():
	if is_network_master():
		position = spawn_position


func _physics_process(delta: float):
	var _u := move_and_slide(_move_input * max_speed)

	if is_network_master():
		_pos_update_time_accumulate += delta
		if _pos_update_time_accumulate >= position_update_rate:
			_pos_update_time_accumulate = 0
			rpc_unreliable("_update_position", position)


func set_move_input(move_input: Vector2):
	_move_input = move_input


remote func _update_position(_position: Vector2):
	position = _position
