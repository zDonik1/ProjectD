extends UnitTest

var coordinator: Node


func before_each():
	coordinator = add_child_autofree(Coordinator.new())


func after_each():
	if has_node("MainMenu"):
		get_node("MainMenu").free()

	if has_node("LobbyUI"):
		get_node("LobbyUI").free()


func test_creates_main_menu_as_sibling_on_ready():
	assert_true(has_node("MainMenu"), "check MainMenu was created")


func test_initializes_main_menu_coordinator_with_self_on_ready():
	assert_eq(get_node("MainMenu").coordinator, coordinator)


func test_creates_lobby_ui_as_sibling_when_main_menu_create_server_pressed_emits():
	get_node("MainMenu").emit_signal("create_server_pressed")
	
	assert_true(has_node("LobbyUI"), "check LobbyUI was created")