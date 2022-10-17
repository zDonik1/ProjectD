class_name TestUtils


static func get_lobby_path():
	return "res://scripts/lobby.gd"


static func get_player_info():
	return {"name": "Some player name"}


static func get_players_info():
	return [
		{"id": 1, "info": {"name": "Player 1"}},
		{"id": 2, "info": {"name": "Player 2"}}
	]
