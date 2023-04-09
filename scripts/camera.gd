extends Camera3D

const TARGET_DISTANCE := 10.0

@export var vertical_resolution := 12
@export var target: Node3D


func _ready():
	$PostProcess.set_instance_shader_parameter("orthographic_size", size)
	print(position.y)


func _process(delta):
	var visible_resolution := Vector2(vertical_resolution, vertical_resolution * 4 / 3)
	var actual_resolution := visible_resolution + Vector2(2, 2)
	$PostProcess.set_instance_shader_parameter("visible_resolution", visible_resolution)
	$PostProcess.set_instance_shader_parameter("actual_resolution", actual_resolution)
	$PostProcess.set_instance_shader_parameter("zoom", actual_resolution / visible_resolution)
	
	var local_position_to_target := basis.z * TARGET_DISTANCE
	var screen_space_pos := _global_to_screen_space(target.global_position + local_position_to_target)
	var pixel_pos := screen_space_pos / size * vertical_resolution
	var ss_actual_pos := Vector3(int(pixel_pos.x), int(pixel_pos.y), pixel_pos.z)
	global_position = _screen_to_global_space(ss_actual_pos / vertical_resolution * size)
	
	#var subpixel_pos := screen_space_pos - ss_actual_pos
	

func _global_to_screen_space(vector: Vector3) -> Vector3:
	return vector * global_transform.basis
	

func _screen_to_global_space(vector: Vector3) -> Vector3:
	return global_transform.basis * vector
