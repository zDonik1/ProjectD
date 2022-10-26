extends IntegTest


func make_lobby_in_env_from_info(info):
	var lobby = Lobby.new()
	lobby.info = info
	lobby.name = "Lobby"
	var sub_st = add_sub_scene_tree_as_child()
	sub_st.st.root.add_child(lobby)
	return lobby


func test_connecting_to_server_properly_initializes_info_on_all_peers():
	var infos = {
		"server": Lobby.LobbyUtils.make_info_with_name("Server"),
		"client1": Lobby.LobbyUtils.make_info_with_name("Client 1"),
		"client2": Lobby.LobbyUtils.make_info_with_name("Client 2")
	}

	var server_lobby = make_lobby_in_env_from_info(infos.server)
	var client_1_lobby = make_lobby_in_env_from_info(infos.client1)
	var client_2_lobby = make_lobby_in_env_from_info(infos.client2)

	server_lobby.create_server()
	client_1_lobby.join_server()
	client_2_lobby.join_server()

	yield(yield_for(0.5), YIELD)

	var expected_players_info = [
		Lobby.LobbyUtils.make_player_info_with_id(
			server_lobby.get_tree().get_network_unique_id(), infos.server
		),
		Lobby.LobbyUtils.make_player_info_with_id(
			client_1_lobby.get_tree().get_network_unique_id(), infos.client1
		),
		Lobby.LobbyUtils.make_player_info_with_id(
			client_2_lobby.get_tree().get_network_unique_id(), infos.client2
		),
	]

	assert_true(
		TestUtils.is_array_similar(
			server_lobby.players_info, expected_players_info
		),
		"check server players_info is updated"
	)
	assert_true(
		TestUtils.is_array_similar(
			client_1_lobby.players_info, expected_players_info
		),
		"check client 1 players_info is updated"
	)
	assert_true(
		TestUtils.is_array_similar(
			client_2_lobby.players_info, expected_players_info
		),
		"check client 2 players_info is updated"
	)
