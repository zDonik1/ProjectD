extends Node3D

const MAX_SPEED := 1


func _ready():
	set_process(false)


func  _physics_process(delta):
	move(calc_move_input(), delta)
	
	
func move(move_input: Vector2, delta: float):
	var horizontal_velocity := move_input * MAX_SPEED
	var velocity := Vector3(horizontal_velocity.x, 0, horizontal_velocity.y)
	translate_object_local(velocity * delta)
	
	
func calc_move_input():
	return Vector2(Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down"))
