extends UnitTest

var main_menu
var lobby


func before_each():
	.before_each()

	lobby = double(Lobby).new()
	stub(lobby, "_ready").to_do_nothing()
	stub(lobby, "create_server").to_do_nothing()
	stub(lobby, "join_server").to_do_nothing()

	main_menu = partial_double("res://scenes/main_menu.tscn").instance()
	main_menu.lobby = lobby
	stub(main_menu, "_ready").to_call_super()
	add_child(main_menu)


func after_each():
	free_node_if_exists("LobbyUI")
	free_node_if_exists("ConnectingMessage")


func test_connects_create_server_button_pressed_to_receiver():
	main_menu.get_node("ButtonList/CreateServer").emit_signal("pressed")

	assert_called(main_menu, "_create_server_button_pressed")


func test_pressing_create_server_button_creates_lobby():
	main_menu._create_server_button_pressed()

	assert_true(
		main_menu.get_parent().has_node("LobbyUI"),
		"check that LobbyUI node was created"
	)


func test_pressing_create_server_button_creates_server_in_lobby():
	main_menu._create_server_button_pressed()

	assert_called(lobby, "create_server")


func test_connects_join_server_button_pressed_to_receiver():
	main_menu.get_node("ButtonList/JoinServer").emit_signal("pressed")

	assert_called(main_menu, "_join_server_button_pressed")


func test_pressing_join_server_button_creates_connecting_message():
	main_menu._join_server_button_pressed()

	assert_true(
		main_menu.get_parent().has_node("ConnectingMessage"),
		"check that ConnectingMessage node was created"
	)
	assert_eq(
		main_menu.get_parent().get_node("ConnectingMessage").message,
		"Connecting to server..."
	)


func test_pressing_join_server_button_joins_server_in_lobby():
	main_menu._join_server_button_pressed()

	assert_called(lobby, "join_server")
