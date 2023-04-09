extends Control

@export var message := "[Message placeholder]" : get = get_message, set = set_message


func set_message(message: String):
	$Label.text = message


func get_message() -> String:
	return $Label.text
