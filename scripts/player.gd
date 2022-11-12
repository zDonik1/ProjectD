extends RigidBody2D

export(int) var max_speed = 200


func set_move_input(move_input):
	linear_velocity = move_input * max_speed