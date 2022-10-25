class_name TestUtils


static func get_player_info():
	return Lobby.LobbyUtils.make_info_with_name("Some player name")


static func is_array_similar(actual_arr: Array, expected_arr: Array) -> bool:
	for elem in expected_arr:
		var found := false
		for act_elem in actual_arr:
			if elem.hash() == act_elem.hash():
				found = true

		if not found:
			return false

	return true
