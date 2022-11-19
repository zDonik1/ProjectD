class_name Coordinator
extends Node

const UINavigation := preload("res://scripts/navigation.gd")
const MainMenu := preload("res://scripts/main_menu.gd")
const LobbyUIScene := preload("res://scenes/lobby_ui.tscn")
const LobbyUIServerScene := preload("res://scenes/lobby_ui_server.tscn")
const ScreenMessageScene := preload("res://scenes/screen_message.tscn")

var navigation: UINavigation


remotesync func _start_game():
	navigation._clear()
	get_node("../Screens").hide()
	get_node("../Game").start_game()


func _on_lobby_ui_start_game_pressed():
	rpc("_start_game")


func _open_lobby_ui(lobby_ui_scene: PackedScene = LobbyUIScene) -> Node:
	var lobby_ui := _make_instance_of_scene_with_name(lobby_ui_scene, "LobbyUI")
	lobby_ui.lobby = _get_lobby()
	navigation.add_ui_screen(lobby_ui)
	return lobby_ui


func _open_lobby_ui_server():
	var lobby_ui := _open_lobby_ui(LobbyUIServerScene)
	var _u := lobby_ui.connect("start_game_pressed", self, "_on_lobby_ui_start_game_pressed")


func _make_instance_of_scene_with_name(packed_scene: PackedScene, name: String) -> Node:
	var scene = packed_scene.instance()
	scene.name = name
	return scene


func _initialize_player_name_in_lobby():
	_get_lobby().info.name = _get_main_menu().player_name


func _get_lobby():
	return get_node("../Lobby")


func _get_main_menu():
	return get_node("../Screens/MainMenuScreen")


func _on_MainMenuScreen_create_server_pressed():
	_initialize_player_name_in_lobby()
	_get_lobby().create_server()

	_open_lobby_ui_server()


func _on_MainMenuScreen_join_server_pressed():
	_initialize_player_name_in_lobby()
	_get_lobby().join_server()
	
	var message_ui := _make_instance_of_scene_with_name(ScreenMessageScene, "ConnectingMessage")
	message_ui.message = "Connecting to server..."
	navigation.add_ui_screen(message_ui)

	yield(get_tree(), "connected_to_server")
	var _u := _open_lobby_ui()
