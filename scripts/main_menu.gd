extends Control

signal create_server_pressed
signal join_server_pressed

var coordinator: Coordinator
var lobby: Lobby


func _ready():
	var _u
	_u = $ButtonList/CreateServer.connect(
		"pressed", self, "_create_server_button_pressed"
	)

	_u = $ButtonList/JoinServer.connect(
		"pressed", self, "_join_server_button_pressed"
	)


func _create_server_button_pressed():
	var lobby_ui = preload("res://scenes/lobby_ui.tscn").instance()
	lobby_ui.name = "LobbyUI"
	lobby_ui.lobby = lobby
	get_parent().add_child(lobby_ui)

	lobby.create_server()


func _join_server_button_pressed():
	var message = preload("res://scenes/screen_message.tscn").instance()
	message.name = "ConnectingMessage"
	message.message = "Connecting to server..."
	get_parent().add_child(message)

	lobby.join_server()
