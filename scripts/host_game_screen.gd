extends Control

signal open_lobby_pressed
signal back_pressed

export var lobby_name_line_edit_path: NodePath

var lobby_name: String setget _set_lobby_name, _get_lobby_name

onready var _lobby_name_line_edit := get_node(lobby_name_line_edit_path) as LineEdit


func _on_OpenLobby_pressed():
	if not _lobby_name_line_edit.text.empty():
		emit_signal("open_lobby_pressed")


func _on_Back_pressed():
	emit_signal("back_pressed")
	

func _set_lobby_name(name: String):
	_lobby_name_line_edit.text = name


func _get_lobby_name() -> String:
	return _lobby_name_line_edit.text
