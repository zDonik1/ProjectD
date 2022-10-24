extends Control


func _ready():
	var _u
	_u = $ButtonList/CreateServer.connect(
		"pressed", self, "_create_server_button_pressed"
	)

	_u = $ButtonList/JoinServer.connect(
		"pressed", self, "_join_server_button_pressed"
	)


func _create_server_button_pressed():
	var lobby = preload("res://scenes/lobby.tscn").instance()
	lobby.name = "LobbyUI"
	get_parent().add_child(lobby)

	get_node("../Lobby").create_server()

	queue_free()


func _join_server_button_pressed():
	var message = preload("res://scenes/screen_message.tscn").instance()
	message.name = "ConnectingMessage"
	get_parent().add_child(message)

	get_node("../Lobby").join_server()
