extends Camera3D

const TARGET_DISTANCE := 20

@export var target: Node3D
@export var render_target: Control


func _process(delta):
	var pixel_to_height_ratio := render_target.size.y / size
	var local_position_to_target := basis.z * TARGET_DISTANCE
	var screen_space_pos := _global_to_screen_space(target.global_position + local_position_to_target)
	var pixel_pos := screen_space_pos * pixel_to_height_ratio
	var ss_actual_pos := Vector3(floor(pixel_pos.x), floor(pixel_pos.y), pixel_pos.z)
	global_position = _screen_to_global_space(ss_actual_pos / pixel_to_height_ratio)
	
	var subpixel_pos := pixel_pos - ss_actual_pos
	render_target.material.set_shader_parameter("offset", Vector2(-subpixel_pos.x, subpixel_pos.y))


func _global_to_screen_space(vector: Vector3) -> Vector3:
	return vector * global_transform.basis
	

func _screen_to_global_space(vector: Vector3) -> Vector3:
	return global_transform.basis * vector
