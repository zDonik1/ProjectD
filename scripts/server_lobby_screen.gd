extends LobbyScreen

signal start_game_pressed


func _on_StartGame_pressed():
	emit_signal("start_game_pressed")
