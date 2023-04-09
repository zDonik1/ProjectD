extends Node

@export var screens_node_path: NodePath

@onready var _screens_node := get_node(screens_node_path) as Node
@onready var _active_screen := _screens_node.get_node("MainMenuScreen") as Control
@onready var _screens := {_active_screen.name: _active_screen}


func show_screen(name: String):
	hide_screen(_active_screen.name)
	_active_screen = _screens[name]
	_screens_node.add_child(_active_screen)


func hide_screen(name: String):
	_screens_node.remove_child(_screens[name])


func remove_all_screens():
	_screens_node.get_parent().remove_child(_screens_node)
	_screens_node.queue_free()


func add_and_show_screen(screen: Control):
	_screens[screen.name] = screen
	show_screen(screen.name)


func remove_screen(name: String = ""):
	var screen_to_remove: Control
	if name.is_empty():
		screen_to_remove = _active_screen
	else:
		screen_to_remove = _screens[name]
	hide_screen(screen_to_remove.name)
	screen_to_remove.queue_free()


func get_screen(name: String) -> Control:
	return _screens[name]
