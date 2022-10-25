extends UnitTest


func test_calls_add_main_menu_on_coordinator_when_ready():
	var main: Node = autofree(preload("res://scripts/main.gd").new())
	var coordinator: Coordinator = double(Coordinator, DOUBLE_STRATEGY.FULL).new()
	coordinator.name = "Coordinator"
	stub(coordinator, "_ready").to_do_nothing()
	stub(coordinator, "add_main_menu").to_do_nothing()
	main.add_child(coordinator)

	add_child(main)

	assert_called(coordinator, "add_main_menu")
