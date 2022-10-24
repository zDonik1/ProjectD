extends GutTest

func test_message_is_set_on_label_on_ready():
	var message = "Some message here"
	var screen_message = autofree(preload("res://scenes/screen_message.tscn").instance())
	screen_message.message = message

	add_child(screen_message)

	assert_eq(screen_message.get_node("Label").text, message)