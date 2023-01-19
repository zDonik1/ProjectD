class_name Coordinator
extends Node

const HostGameScreen := preload("res://scripts/host_game_screen.gd")
const ServerListScreen := preload("res://scripts/server_list_screen.gd")

const LobbyScreenScene := preload("res://screens/lobby_screen.tscn")
const ServerLobbyScreenScene := preload("res://screens/server_lobby_screen.tscn")
const HostGameScreenScene := preload("res://screens/host_game_screen.tscn")
const ServerListScreenScene := preload("res://screens/server_list_screen.tscn")
const UiNavigation := preload("res://scripts/navigation.gd")

export var navigation_path: NodePath

onready var navigation := get_node(navigation_path) as UiNavigation

var _lobby: Lobby


func _ready():
	var _u := get_tree().connect(
		"server_disconnected", self, "_on_server_disconnected"
	)


remotesync func _start_game():
	navigation.remove_all_screens()
	get_node("../Game").start_game(_lobby)


func _open_server_lobby_screen():
	_open_lobby_screen(ServerLobbyScreenScene)


func _open_lobby_screen(lobby_screen_scene: PackedScene = LobbyScreenScene):
	var lobby_screen := _make_instance_of_scene_with_name(lobby_screen_scene, "LobbyScreen") as LobbyScreen
	lobby_screen.lobby = _lobby
	var _u := lobby_screen.connect(
		"start_game_pressed", self, "_on_LobbyScreen_start_game_pressed"
	)
	_u = lobby_screen.connect(
		"back_pressed", self, "_on_LobbyScreen_back_pressed"
	)

	navigation.add_and_show_screen(lobby_screen)


func _open_main_menu():
	navigation.remove_screen()
	navigation.show_screen("MainMenuScreen")


func _initialize_lobby():
	_lobby = Lobby.new()
	_lobby.name = "Lobby"
	_lobby.info.name = navigation.get_screen("MainMenuScreen").player_name
	get_parent().add_child(_lobby)


func _on_server_disconnected():
	_open_main_menu()
	get_parent().remove_child(_lobby)
	_lobby.queue_free()


func _on_MainMenuScreen_host_game_pressed():
	var host_game_screen := _make_instance_of_scene_with_name(HostGameScreenScene, "HostGameScreen") as HostGameScreen
	navigation.add_and_show_screen(host_game_screen)
	host_game_screen.lobby_name = (
		navigation.get_screen("MainMenuScreen").player_name
		+ "'s Lobby"
	)
	host_game_screen.connect(
		"open_lobby_pressed", self, "_on_HostGameScreen_open_lobby_pressed"
	)
	host_game_screen.connect(
		"back_pressed", self, "_on_HostGameScreen_back_ressed"
	)


func _on_MainMenuScreen_join_server_pressed():
	var server_list_screen := _make_instance_of_scene_with_name(ServerListScreenScene, "ServerListScreen") as ServerListScreen
	server_list_screen.connect(
		"join_server_pressed", self, "_on_ServerListScreen_join_server_pressed"
	)
	server_list_screen.connect(
		"back_pressed", self, "_on_ServerListScreen_back_pressed"
	)
	navigation.add_and_show_screen(server_list_screen)


func _on_HostGameScreen_open_lobby_pressed():
	_initialize_lobby()
	_lobby.create_server()
	_open_server_lobby_screen()
	navigation.get_screen("LobbyScreen").init_server_advertiser(
		navigation.get_screen("HostGameScreen").lobby_name
	)


func _on_HostGameScreen_back_ressed():
	_open_main_menu()


func _on_ServerListScreen_join_server_pressed(ip: String):
	_initialize_lobby()
	_lobby.join_server(ip)

	navigation.get_screen("MessageScreen").message = "Connecting to server..."
	navigation.show_screen("MessageScreen")

	yield(get_tree(), "connected_to_server")

	_open_lobby_screen()


func _on_ServerListScreen_back_pressed():
	_open_main_menu()


func _on_LobbyScreen_back_pressed():
	navigation.remove_screen("LobbyScreen")
	navigation.show_screen("HostGameScreen")


func _on_LobbyScreen_start_game_pressed():
	rpc("_start_game")


func _make_instance_of_scene_with_name(
	packed_scene: PackedScene, name: String
) -> Node:
	var scene = packed_scene.instance()
	scene.name = name
	return scene
