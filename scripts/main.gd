extends Node

func _ready():
	$Coordinator.navigation = $Navigation
	$Coordinator.add_main_menu()
