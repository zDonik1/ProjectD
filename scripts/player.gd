extends CharacterBody2D

var max_speed := 200
var position_update_rate := 0.03
var spawn_position := Vector2.ZERO

var _pos_update_time_accumulate := 0.0
var _move_input := Vector2.ZERO


func _ready():
	if is_multiplayer_authority():
		position = spawn_position


func _physics_process(delta: float):
	set_velocity(_move_input * max_speed)
	move_and_slide()
	var _u := velocity

	if is_multiplayer_authority():
		_pos_update_time_accumulate += delta
		if _pos_update_time_accumulate >= position_update_rate:
			_pos_update_time_accumulate = 0
			rpc_unreliable("_update_position", position)


func set_move_input(move_input: Vector2):
	_move_input = move_input


@rpc("any_peer") func _update_position(_position: Vector2):
	position = _position
