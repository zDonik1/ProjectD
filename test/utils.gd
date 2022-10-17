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


static func make_lobby(tst_inst):
	var lobby = tst_inst.partial_double(get_lobby_path(), tst_inst.DOUBLE_STRATEGY.FULL).new()
	tst_inst.stub(lobby, "_ready").to_call_super()
	tst_inst.add_child(lobby)
	return lobby
