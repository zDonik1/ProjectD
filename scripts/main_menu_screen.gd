extends Control

signal host_game_pressed
signal join_server_pressed

var player_name: String setget set_player_name, get_player_name


func set_player_name(_name: String):
	$VBoxContainer/PlayerName.text = _name


func get_player_name():
	return $VBoxContainer/PlayerName.text


func _on_HostGame_pressed():
	emit_signal("host_game_pressed")


func _on_JoinServer_pressed():
	emit_signal("join_server_pressed")
