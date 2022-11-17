extends Node

var _ui_stack := []


func add_ui_screen(screen: Node):
	_ui_stack.append(screen)
	get_parent().add_child(screen)


func set_ui_screen(screen: Node):
	_clear()
	add_ui_screen(screen)


func _clear():
	for node in _ui_stack:
		get_parent().remove_child(node)
		node.queue_free()
	_ui_stack.clear()
	