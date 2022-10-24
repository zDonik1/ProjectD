extends GutTest


func test_create_server_button_click_creates_server_and_opens_lobby_ui():
	var sub_st = add_child_autofree(SubSceneTree.new())
	var root = sub_st.st.root

	var main_menu = preload("res://scenes/main_menu.tscn").instance()
	main_menu.name = "MainMenu"
	root.add_child(main_menu)

	var lobby = Lobby.new()
	lobby.info = Lobby.LobbyUtils.make_info_with_name("Server")
	lobby.name = "Lobby"
	root.add_child(lobby)

	var create_server_button = main_menu.get_node("ButtonList/CreateServer")
	create_server_button.emit_signal("pressed")

	sub_st.st.idle(0.1)

	assert_true(
		lobby.get_tree().is_network_server(),
		"check that peer is network server"
	)
	assert_true(
		root.has_node("LobbyUI"),
		"check that LobbyUI scene was created under main node"
	)
	assert_false(
		root.has_node("MainMenu"),
		"check that MainMenu scene was deleted under main node"
	)
