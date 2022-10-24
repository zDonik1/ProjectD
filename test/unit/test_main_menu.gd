extends UnitTest


func test_connects_create_server_button_pressed_to_receiver():
	var main_menu = partial_double("res://scenes/main_menu.tscn").instance()
	stub(main_menu, "_ready").to_call_super()
	add_child(main_menu)

	main_menu.get_node("ButtonList/CreateServer").emit_signal("pressed")

	assert_called(main_menu, "_create_server_button_pressed")
