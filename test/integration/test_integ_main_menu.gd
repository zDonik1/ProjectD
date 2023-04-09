extends IntegTest

const Main = preload("res://scripts/main.gd")
const MainMenu = preload("res://scripts/main_menu.gd")

var scene_tree: SceneTree
var main: Main
var main_menu: MainMenu


func before_each():
	var sub_st := add_sub_scene_tree_as_child()
	scene_tree = sub_st.st
	main = make_main_in_sub_st(sub_st)
	main_menu = main.get_node("MainMenu")


func test_create_server_button_click_creates_server_and_opens_lobby_ui():
	_emulate_create_server_press()
	var _u := scene_tree.idle(0.1)

	assert_true(
		scene_tree.is_server(), "check that peer is network server"
	)
	assert_true(
		main.has_node("LobbyUI"),
		"check that LobbyUI scene was created under main node"
	)


func test_join_server_button_click_joins_server_and_shows_connecting_message():
	main_menu.get_node("ButtonList/JoinServer").emit_signal("pressed")
	var _u := scene_tree.idle(0.1)

	assert_true(
		scene_tree.has_multiplayer_peer(), "check that peer is valid"
	)
	assert_true(
		main.has_node("ConnectingMessage"),
		"check that ConnectingMessage scene was created under main node"
	)
	assert_eq(
		main.get_node("ConnectingMessage").message, "Connecting to server..."
	)


func test_player_name_is_updated_to_lobby_ui():
	var name := "Some player"
	main_menu.get_node("ButtonList/PlayerName").text = name

	_emulate_create_server_press()
	var _u := scene_tree.idle(0.1)

	assert_eq(main.get_node("LobbyUI").get_item_names(), [name])
	

func _emulate_create_server_press():
	main_menu.get_node("ButtonList/CreateServer").emit_signal("pressed")