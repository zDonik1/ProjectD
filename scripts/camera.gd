extends Camera3D

const TARGET_DISTANCE := 20

@export var vertical_resolution := 120
@export var target: Node3D


func _ready():
	$PostProcess.material_override.set_shader_parameter("orthographic_size", size)
	print(position.y)


func _process(delta):
	var visible_resolution := Vector2(vertical_resolution * 4 / 3, vertical_resolution)
	var actual_resolution := visible_resolution + Vector2(1, 1)
	
	var pixel_to_height_ratio := visible_resolution.y / size
	var local_position_to_target := basis.z * TARGET_DISTANCE
	var screen_space_pos := _global_to_screen_space(target.global_position + local_position_to_target)
	var pixel_pos := screen_space_pos * pixel_to_height_ratio
	var ss_actual_pos := Vector3(floor(pixel_pos.x), floor(pixel_pos.y), pixel_pos.z)
	global_position = _screen_to_global_space(ss_actual_pos / pixel_to_height_ratio)
	
	var subpixel_pos := pixel_pos - ss_actual_pos
	var pixel_offset := Vector2(-subpixel_pos.x, subpixel_pos.y) - Vector2(-0.5, 0.5)
	print(pixel_offset)
	var norm_offset := pixel_offset / Vector2(visible_resolution.x, visible_resolution.y) * 2
	
	var material: ShaderMaterial = $PostProcess.material_override
	material.set_shader_parameter("resolution", actual_resolution)
	material.set_shader_parameter("zoom", actual_resolution / visible_resolution)
	material.set_shader_parameter("offset", norm_offset)


func _global_to_screen_space(vector: Vector3) -> Vector3:
	return vector * global_transform.basis
	

func _screen_to_global_space(vector: Vector3) -> Vector3:
	return global_transform.basis * vector
