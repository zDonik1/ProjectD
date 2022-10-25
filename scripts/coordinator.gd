class_name Coordinator
extends Node


func _ready():
	var main_menu: Node = load("res://scenes/main_menu.tscn").instance()
	main_menu.name = "MainMenu"
	main_menu.coordinator = self
	var _u := main_menu.connect("create_server_pressed", self, "_add_lobby_ui")
	get_parent().add_child(main_menu)


func _add_lobby_ui():
	var lobby_ui: Node = load("res://scenes/lobby_ui.tscn").instance()
	lobby_ui.name = "LobbyUI"
	lobby_ui.lobby = get_node("../Lobby")
	get_parent().add_child(lobby_ui)
