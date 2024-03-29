extends Node
const PlayerScene := preload("res://scenes/player.tscn")
const Player := preload("res://scripts/player.gd")

var _rng := RandomNumberGenerator.new()
var _player: Player  # holds current game player
var _lobby: Lobby


func start_game(lobby: Lobby):
	_lobby = lobby
	_instantiate_all_payers()
	$PlayerController.player = _player
	$PlayerController.set_process(true)
	$InGameUI.show()


func _instantiate_all_payers():
	_rng.randomize()
	for player_info in _lobby.players_info:
		var current_id := player_info.id as int
		var player := _instance_player(current_id)

		if current_id == get_tree().get_unique_id():
			_player = player
	

func _instance_player(id: int) -> Node:
	var player := PlayerScene.instantiate()
	player.name = "Player_{0}".format([id])
	player.spawn_position = Vector2(
		_rng.randi_range(0, ProjectSettings.get_setting("display/window/size/viewport_width")),
		_rng.randi_range(0, ProjectSettings.get_setting("display/window/size/viewport_height"))
	)
	player.set_multiplayer_authority(id)
	$World.add_child(player)
	return player
