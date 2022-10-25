extends Control

signal create_server_pressed
signal join_server_pressed

var coordinator: Coordinator


func _ready():
	var _u: int
	_u = $ButtonList/CreateServer.connect(
		"pressed", self, "_on_create_server_button_pressed"
	)
	_u = $ButtonList/JoinServer.connect(
		"pressed", self, "_on_join_server_button_pressed"
	)


func _on_create_server_button_pressed():
	emit_signal("create_server_pressed")


func _on_join_server_button_pressed():
	emit_signal("join_server_pressed")
