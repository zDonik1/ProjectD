extends UnitTest

var main_menu

func before_each():
	.before_each()
	main_menu = partial_double("res://scenes/main_menu.tscn").instance()
	stub(main_menu, "_ready").to_call_super()
	add_child(main_menu)


func test_connects_create_server_button_pressed_to_receiver():
	stub(main_menu, "_create_server_button_pressed").to_do_nothing()
	
	main_menu.get_node("ButtonList/CreateServer").emit_signal("pressed")

	assert_called(main_menu, "_create_server_button_pressed")


func test_pressing_create_server_button_creates_lobby():
	main_menu._create_server_button_pressed()

	assert_true(
		main_menu.get_parent().has_node("LobbyUI"),
		"check that LobbyUI node was created"
	)

	$LobbyUI.free()
