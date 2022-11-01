class_name Coordinator
extends Node

const MainMenu := preload("res://scripts/main_menu.gd")

var _node_being_added: Node


func add_main_menu():
	var coro = _add_control_node_to_parent(
		"res://scenes/main_menu.tscn", "MainMenu"
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
	_get_lobby().create_server()

	var coro = _add_control_node_to_parent(
		"res://scenes/lobby_ui.tscn", "LobbyUI"
	)
	_node_being_added.lobby = _get_lobby()
	coro.resume()


func _on_join_server_pressed():
	_get_lobby().join_server()

	var coro = _add_control_node_to_parent("res://scenes/screen_message.tscn", "ConnectingMessage")
	_node_being_added.message = "Connecting to server..."
	coro.resume()


func _add_control_node_to_parent(path: String, name: String):
	_node_being_added = load(path).instance()
	_node_being_added.name = name
	yield()
	get_parent().add_child(_node_being_added)


func _get_lobby():
	return get_node("../Lobby")
