extends UnitTest

func after_each():
	get_node("MainMenu").free()

func test_initializes_main_menu_as_sibling_on_ready():
	var coordinator: Node = add_child_autofree(Coordinator.new())

	assert_true(has_node("MainMenu"), "check MainMenu was created")
	assert_eq(get_node("MainMenu").coordinator, coordinator)
