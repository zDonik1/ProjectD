extends Control

export var message := "[Message placeholder]"

func _ready():
	$Label.text = message
