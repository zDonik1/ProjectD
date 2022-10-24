extends GutTest

var scene_tree
var main_menu
var root


func before_each():
	var sub_st = add_child_autofree(SubSceneTree.new())
	root = sub_st.st.root
	scene_tree = sub_st.st

	main_menu = preload("res://scenes/main_menu.tscn").instance()
	main_menu.name = "MainMenu"
	root.add_child(main_menu)

	var lobby = Lobby.new()
	lobby.name = "Lobby"
	root.add_child(lobby)


func test_create_server_button_click_creates_server_and_opens_lobby_ui():
	var create_server_button = main_menu.get_node("ButtonList/CreateServer")
	
	create_server_button.emit_signal("pressed")
	scene_tree.idle(0.1)

	assert_true(
		scene_tree.is_network_server(), "check that peer is network server"
	)
	assert_true(
		root.has_node("LobbyUI"),
		"check that LobbyUI scene was created under main node"
	)


func test_join_server_button_click_joins_server_and_shows_connecting_message():
	var join_server_button = main_menu.get_node("ButtonList/JoinServer")
	
	join_server_button.emit_signal("pressed")
	scene_tree.idle(0.1)

	assert_true(
		scene_tree.has_network_peer(), "check that peer is valid (connected)"
	)
	assert_true(
		root.has_node("ConnectingMessage"),
		"check that LobbyUI scene was created under main node"
	)
	assert_eq(root.get_node("ConnectingMessage").message, "Connecting to server...")
