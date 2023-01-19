extends LobbyScreen

signal start_game_pressed

export var server_advertiser_path: NodePath

onready var _server_advertiser := get_node(server_advertiser_path) as ServerAdvertiser


func _on_StartGame_pressed():
	emit_signal("start_game_pressed")
