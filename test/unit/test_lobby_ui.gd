extends UnitTest


func test_setting_names_to_list_with_existing_items_overrides_it():
	var names = [
		"My first item", "This is a second item", "Here is a third one"
	]
	var lobby_ui = autofree(preload("res://scenes/lobby_ui.tscn").instance())
	lobby_ui.add_item("Some other item")

	lobby_ui.set_item_names(names)

	assert_eq(lobby_ui.get_item_names(), names)
	