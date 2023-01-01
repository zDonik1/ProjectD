extends Control

signal host_game_pressed
signal join_server_pressed


func _on_HostGame_pressed():
	emit_signal("host_game_pressed")


func _on_JoinServer_pressed():
	emit_signal("join_server_pressed")
