extends UnitTest

var main_menu
var lobby


func before_each():
	super.before_each()
	main_menu = partial_double("res://scenes/main_menu.tscn").instantiate()
	stub(main_menu, "_ready").to_call_super()
	watch_signals(main_menu)
	add_child(main_menu)


func test_create_server_pressed_emitted_when_create_server_button_pressed_emitted():
	main_menu.get_node("ButtonList/CreateServer").emit_signal("pressed")

	assert_signal_emitted(main_menu, "create_server_pressed")


func test_join_server_pressed_emitted_when_join_server_button_pressed_emitted():
	main_menu.get_node("ButtonList/JoinServer").emit_signal("pressed")

	assert_signal_emitted(main_menu, "join_server_pressed")
