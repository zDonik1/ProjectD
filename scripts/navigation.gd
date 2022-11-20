extends Node

onready var _active_screen: Control = get_screen("MainMenuScreen")


func show_screen(name: String):
	_deactivate_screen(_active_screen)
	_active_screen = get_screen(name)
	_activate_screen(_active_screen)
	

func show_all_screens():
	_activate_screen(_get_screens_root())
	
	
func hide_all_screens():
	_deactivate_screen(_get_screens_root())
	
	
func get_screen(name: String) -> Control:
	return _get_screens_root().get_node(name) as Control


func add_screen(screen: Control):
	_get_screens_root().add_child(screen)


func remove_screen(name: String):
	var screen_to_remove := get_screen(name)
	_get_screens_root().remove_child(screen_to_remove)
	screen_to_remove.queue_free()


func _activate_screen(screen: Control):
	screen.show()
	screen.set_process(true)


func _deactivate_screen(screen: Control):
	screen.hide()
	screen.set_process(false)

func _get_screens_root() -> Control:
	return get_node("/root/Main/Screens") as Control
