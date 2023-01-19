extends Control

signal host_game_pressed
signal join_server_pressed

export var player_name_line_edit_path: NodePath

onready var _player_name_line_edit := get_node(player_name_line_edit_path) as LineEdit

var player_name: String setget , _get_player_name


func _on_HostGame_pressed():
	emit_signal("host_game_pressed")


func _on_JoinServer_pressed():
	emit_signal("join_server_pressed")


func _get_player_name() -> String:
	return _player_name_line_edit.text
