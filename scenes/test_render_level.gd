extends Node

@export var pixel_resolution := Vector2i(160, 120)
@export_node_path("SubViewportContainer") var pixel_container_path
@export_node_path("SubViewport") var pixel_viewport_path

@onready var _pixel_container := get_node(pixel_container_path) as SubViewportContainer
@onready var _pixel_viewport := get_node(pixel_viewport_path) as SubViewport


func _ready():
	var width := ProjectSettings.get_setting("display/window/size/viewport_width") as float
	var height := ProjectSettings.get_setting("display/window/size/viewport_height") as float
	if width / height != 4.0 / 3.0:
		Logger.error("Please make sure that the ratio of screen width to height is 4:3. 
			Current widht:height = {0}:{1}".format([width, height]))
		return
	
	var window_resolution := Vector2i(width, height)
	var full_resolution := pixel_resolution + Vector2i.ONE
	_pixel_viewport.size = full_resolution
	_pixel_container.size = full_resolution
	var scale = window_resolution / pixel_resolution
	_pixel_container.scale = scale
	_pixel_container.position.y = -scale.y
