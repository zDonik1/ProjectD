extends UnitTest

var main_menu
var lobby

func before_each():
	.before_each()

	lobby = double(Lobby).new()
	lobby.name = "Lobby"
	stub(lobby, "_ready").to_do_nothing()
	stub(lobby, "create_server").to_do_nothing()
	add_child(lobby)

	main_menu = partial_double("res://scenes/main_menu.tscn").instance()
	stub(main_menu, "_ready").to_call_super()
	add_child(main_menu)


func after_each():
	if has_node("LobbyUI"):
		$LobbyUI.free()


func test_connects_create_server_button_pressed_to_receiver():
	main_menu.get_node("ButtonList/CreateServer").emit_signal("pressed")

	assert_called(main_menu, "_create_server_button_pressed")


func test_pressing_create_server_button_creates_lobby():
	main_menu._create_server_button_pressed()

	assert_true(
		main_menu.get_parent().has_node("LobbyUI"),
		"check that LobbyUI node was created"
	)


func test_pressing_create_server_button_deletes_main_menu():
	main_menu._create_server_button_pressed()
	
	assert_true(
		main_menu.is_queued_for_deletion(),
		"check that MainMenu is about to be deleted"
	)


func test_pressing_create_server_button_creates_server_in_lobby():
	main_menu._create_server_button_pressed()

	assert_called(lobby, "create_server")


func test_connects_join_server_button_pressed_to_receiver():
	main_menu.get_node("ButtonList/JoinServer").emit_signal("pressed")

	assert_called(main_menu, "_join_server_button_pressed")