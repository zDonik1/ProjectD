class_name TestUtils


static func get_player_info():
	return Lobby.LobbyUtils.make_info_with_name("Some player name")


static func get_players_info():
	return [
		Lobby.Utils.make_player_info_with_id(
			1, Lobby.LobbyUtils.make_info_with_name("Player 1")
		),
		Lobby.Utils.make_player_info_with_id(
			2, Lobby.LobbyUtils.make_info_with_name("Player 2")
		)
	]


static func make_lobby(tst_inst):
	var lobby = make_free_lobby(tst_inst)
	tst_inst.add_child(lobby)
	return lobby


static func make_free_lobby(tst_inst):
	var lobby = tst_inst.autofree(Lobby.new())
	lobby.name = "Lobby"
	return lobby


static func is_array_similar(actual_arr, expected_arr):
	for elem in expected_arr:
		var found = false
		for act_elem in actual_arr:
			if elem.hash() == act_elem.hash():
				found = true

		if not found:
			return false

	return true
