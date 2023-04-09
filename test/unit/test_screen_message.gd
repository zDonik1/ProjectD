extends GutTest

var screen_message


func before_each():
	screen_message = autofree(
		preload("res://scenes/screen_message.tscn").instantiate()
	)


func test_message_is_set_on_label_on_ready():
	var message = "Some message here"
	screen_message.message = message

	add_child(screen_message)

	assert_eq(screen_message.get_node("Label").text, message)


func test_message_defaults_to_placeholder():
	assert_eq(screen_message.message, "[Message placeholder]")
