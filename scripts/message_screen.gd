extends Control

export var message := "[Message placeholder]" setget set_message, get_message


func set_message(var message: String):
	$Label.text = message


func get_message() -> String:
	return $Label.text
