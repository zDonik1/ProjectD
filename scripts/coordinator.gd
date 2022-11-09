class_name Coordinator
extends Node

const MainMenu := preload("res://scripts/main_menu.gd")
const MainMenuScene := preload("res://scenes/main_menu.tscn")
const LobbyUIScene := preload("res://scenes/lobby_ui.tscn")
const LobbyUIServerScene := preload("res://scenes/lobby_ui_server.tscn")
const ScreenMessageScene := preload("res://scenes/screen_message.tscn")

var _node_being_added: Node


func add_main_menu():
	var coro = _add_control_node_to_parent(
		MainMenuScene, "MainMenu"
	)
	var _u: int
	_u = _node_being_added.connect(
		"create_server_pressed", self, "_on_create_server_pressed"
	)
	_u = _node_being_added.connect(
		"join_server_pressed", self, "_on_join_server_pressed"
	)
	coro.resume()


func _on_create_server_pressed():
	_initialize_player_name_in_lobby()
	_get_lobby().create_server()

	_open_lobby_ui(LobbyUIServerScene)


func _on_join_server_pressed():
	_initialize_player_name_in_lobby()
	_get_lobby().join_server()
	
	var coro = _add_control_node_to_parent(ScreenMessageScene, "ConnectingMessage")
	_node_being_added.message = "Connecting to server..."
	coro.resume()

	yield(get_tree(), "connected_to_server")
	_open_lobby_ui()


func _open_lobby_ui(lobby_ui: PackedScene = LobbyUIScene):
	var coro = _add_control_node_to_parent(
		lobby_ui, "LobbyUI"
	)
	_node_being_added.lobby = _get_lobby()
	coro.resume()


func _add_control_node_to_parent(scene: PackedScene, name: String):
	_node_being_added = scene.instance()
	_node_being_added.name = name
	yield()
	get_parent().add_child(_node_being_added)


func _initialize_player_name_in_lobby():
	_get_lobby().info.name = _get_main_menu().player_name


func _get_lobby():
	return get_node("../Lobby")


func _get_main_menu():
	return get_node("../MainMenu")