extends "res://scripts/lobby_screen.gd"

signal start_game_pressed

var lobby: Lobby

func _ready():
	var _u := lobby.connect("peer_added", self, "_on_Lobby_peer_added")
	_u = lobby.connect("peer_removed", self, "_on_Lobby_peer_removed")


func _on_StartGame_pressed():
	emit_signal("start_game_pressed")
