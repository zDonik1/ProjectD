class_name Coordinator
extends Node

const ServerLobbyScreenScene := preload("res://screens/server_lobby_screen.tscn")
const UINavigation := preload("res://scripts/navigation.gd")

export var lobby_path: NodePath
export var navigation_path: NodePath

onready var lobby: Lobby = get_node(lobby_path)
onready var navigation: UINavigation = get_node(navigation_path)


remotesync func _start_game():
	navigation.hide_all_screens()
	get_node("../Game").start_game()


func _on_lobby_ui_start_game_pressed():
	rpc("_start_game")


func _open_lobby_ui_server():
	navigation.remove_screen("LobbyScreen")
	var lobby_screen := _make_instance_of_scene_with_name(ServerLobbyScreenScene, "LobbyScreen")
	lobby_screen.lobby = lobby
	navigation.add_screen(lobby_screen)
	var _u := lobby_screen.connect("start_game_pressed", self, "_on_lobby_ui_start_game_pressed")


func _make_instance_of_scene_with_name(packed_scene: PackedScene, name: String) -> Node:
	var scene = packed_scene.instance()
	scene.name = name
	return scene


func _initialize_player_name_in_lobby():
	lobby.info.name = navigation.get_screen("MainMenuScreen").player_name


func _on_MainMenuScreen_create_server_pressed():
	_initialize_player_name_in_lobby()
	lobby.create_server()

	_open_lobby_ui_server()


func _on_MainMenuScreen_join_server_pressed():
	_initialize_player_name_in_lobby()
	lobby.join_server()
	
	navigation.get_screen("MessageScreen").message = "Connecting to server..."
	navigation.show_screen("MessageScreen")

	yield(get_tree(), "connected_to_server")
	navigation.show_screen("LobbyScreen")
