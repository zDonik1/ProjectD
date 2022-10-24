extends Control


func _ready():
	var _u = $ButtonList/CreateServer.connect(
		"pressed", self, "_create_server_button_pressed"
	)


func _create_server_button_pressed():
	var lobby = preload("res://scenes/lobby.tscn").instance()
	lobby.name = "LobbyUI"
	get_parent().add_child(lobby)
