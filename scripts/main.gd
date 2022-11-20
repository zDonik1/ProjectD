extends Node


func _ready():
	if OS.get_cmdline_args().size() > 0:
		match OS.get_cmdline_args()[0]:
			"--startserver":
				_start_server_game()
			"--startclient":
				_start_client_game()


func _start_server_game():
	$Screens/MainMenuScreen.emit_signal("create_server_pressed")

	yield(get_tree().create_timer(0.5), "timeout")

	$Navigation.get_screen("LobbyScreen").emit_signal("start_game_pressed")


func _start_client_game():
	$Screens/MainMenuScreen.emit_signal("join_server_pressed")
