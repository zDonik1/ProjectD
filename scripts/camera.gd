extends Camera3D

const TARGET_DISTANCE := 20

@export var target: Node3D
@export var render_target: Control


func _process(delta):
	var camera_offset_from_target := basis.z * TARGET_DISTANCE
	var camera_global_position := target.global_position + camera_offset_from_target
	var camera_space_pos := _global_to_camera_space(camera_global_position)
	var pixel_to_height_ratio := render_target.size.y / size
	var pixel_pos := camera_space_pos * pixel_to_height_ratio
	var camera_space_snapped_pos := Vector3(floor(pixel_pos.x), floor(pixel_pos.y), pixel_pos.z)
	global_position = _camera_to_global_space(camera_space_snapped_pos / pixel_to_height_ratio)
	
	var subpixel_offset := pixel_pos - camera_space_snapped_pos
	render_target.material.set_shader_parameter("offset", Vector2(-subpixel_offset.x, subpixel_offset.y))


func _global_to_camera_space(vector: Vector3) -> Vector3:
	return vector * global_transform.basis
	

func _camera_to_global_space(vector: Vector3) -> Vector3:
	return global_transform.basis * vector
