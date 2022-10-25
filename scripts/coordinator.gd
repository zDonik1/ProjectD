class_name Coordinator
extends Node

func _ready():
	var main_menu: Node = load("res://scenes/main_menu.tscn").instance()
	main_menu.name = "MainMenu"
	main_menu.coordinator = self
	get_parent().add_child(main_menu)