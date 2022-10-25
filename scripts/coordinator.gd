class_name Coordinator
extends Node


func _ready():
	var main_menu: Node = load("res://scenes/main_menu.tscn").instance()
	main_menu.name = "MainMenu"
	main_menu.coordinator = self
	var _u: int
	_u = main_menu.connect("create_server_pressed", self, "_add_lobby_ui")
	_u = main_menu.connect("join_server_pressed", self, "_add_connecting_message")
	get_parent().add_child(main_menu)


func _add_lobby_ui():
	var lobby_ui: Node = load("res://scenes/lobby_ui.tscn").instance()
	lobby_ui.name = "LobbyUI"
	lobby_ui.lobby = get_node("../Lobby")
	get_parent().add_child(lobby_ui)


func _add_connecting_message():
	var connecting_message: Node = load("res://scenes/screen_message.tscn").instance()
	connecting_message.name = "ConnectingMessage"
	get_parent().add_child(connecting_message)