extends Node

const PlayerScene := preload("res://scenes/player.tscn")
const Player := preload("res://scripts/player.gd")

var lobby: Lobby

var _rng := RandomNumberGenerator.new()
var _player: Player  # holds current game player


func _ready():
	_instantiate_all_payers()
	$PlayerController.player = _player


func _instantiate_all_payers():
	_rng.randomize()
	for player_info in lobby.players_info:
		var current_id := player_info.id as int
		var player := _instance_player(current_id)

		if current_id == get_tree().get_network_unique_id():
			_player = player
	

func _instance_player(id: int) -> Node:
	var player := PlayerScene.instance()
	player.name = "Player_{0}".format([id])
	player.spawn_position = Vector2(
		_rng.randi_range(0, ProjectSettings.get_setting("display/window/size/width")),
		_rng.randi_range(0, ProjectSettings.get_setting("display/window/size/height"))
	)
	player.set_network_master(id)
	add_child(player)
	return player
