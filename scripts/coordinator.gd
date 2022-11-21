class_name Coordinator
extends Node

const LobbyScreenScene := preload("res://screens/lobby_screen.tscn")
const ServerLobbyScreenScene := preload("res://screens/server_lobby_screen.tscn")
const UiNavigation := preload("res://scripts/navigation.gd")

export var navigation_path: NodePath

onready var navigation := get_node(navigation_path) as UiNavigation


func _ready():
	var _u := get_tree().connect("server_disconnected", self, "_on_server_disconnected")

remotesync func _start_game():
	navigation.hide_all_screens()
	get_node("../Game").start_game()


func _open_server_lobby_screen():
	_open_lobby_screen(ServerLobbyScreenScene)


func _open_lobby_screen(lobby_screen_scene: PackedScene = LobbyScreenScene):
	var lobby_screen := _make_instance_of_scene_with_name(lobby_screen_scene, "LobbyScreen") as LobbyScreen
	lobby_screen.lobby = _get_lobby()
	var _u := lobby_screen.connect("start_game_pressed", self, "_on_LobbyScreen_start_game_pressed")
	_u = lobby_screen.connect("back_pressed", self, "_on_LobbyScreen_back_pressed")
	
	navigation.add_screen(lobby_screen)
	navigation.show_screen("LobbyScreen")


func _make_instance_of_scene_with_name(packed_scene: PackedScene, name: String) -> Node:
	var scene = packed_scene.instance()
	scene.name = name
	return scene


func _initialize_lobby():
	var lobby := Lobby.new()
	lobby.name = "Lobby"
	lobby.info.name = navigation.get_screen("MainMenuScreen").player_name
	get_parent().add_child(lobby)


func _get_lobby():
	return get_node("../Lobby")


func _on_server_disconnected():
	navigation.show_screen("MainMenuScreen")


func _on_MainMenuScreen_create_server_pressed():
	_initialize_lobby()
	_get_lobby().create_server()

	_open_server_lobby_screen()


func _on_MainMenuScreen_join_server_pressed():
	_initialize_lobby()
	_get_lobby().join_server()
	
	navigation.get_screen("MessageScreen").message = "Connecting to server..."
	navigation.show_screen("MessageScreen")

	yield(get_tree(), "connected_to_server")
	
	_open_lobby_screen()


func _on_LobbyScreen_back_pressed():
	navigation.remove_screen("LobbyScreen")
	navigation.show_screen("MainMenuScreen")
	
	var lobby := _get_lobby() as Lobby
	get_parent().remove_child(lobby)
	lobby.queue_free()


func _on_LobbyScreen_start_game_pressed():
	rpc("_start_game")
