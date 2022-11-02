extends IntegTest


func test_connecting_to_server_properly_initializes_info_on_all_peers():
	var names = {
		server = "Server",
		client1 = "Client 1",
		client2 = "Client 2",
	}

	var server_main = instantiate_server_with_name(names.server)
	var client1_main = instantiate_client_with_name(names.client1)
	var client2_main = instantiate_client_with_name(names.client1)

	yield(yield_for(0.3), YIELD)

	var expected_players_info = [
		Lobby.LobbyUtils.make_player_info_with_id(
			server_main.get_tree().get_network_unique_id(), 
			Lobby.LobbyUtils.make_info_with_name(names.server)
		),
		Lobby.LobbyUtils.make_player_info_with_id(
			client1_main.get_tree().get_network_unique_id(), 
			Lobby.LobbyUtils.make_info_with_name(names.client1)
		),
		Lobby.LobbyUtils.make_player_info_with_id(
			client2_main.get_tree().get_network_unique_id(), 
			Lobby.LobbyUtils.make_info_with_name(names.client1)
		),
	]

	assert_true(
		TestUtils.is_array_similar(
			server_main.get_node("Lobby").players_info, expected_players_info
		),
		"check server players_info is updated"
	)
	assert_true(
		TestUtils.is_array_similar(
			client1_main.get_node("Lobby").players_info, expected_players_info
		),
		"check client 1 players_info is updated"
	)
	assert_true(
		TestUtils.is_array_similar(
			client2_main.get_node("Lobby").players_info, expected_players_info
		),
		"check client 2 players_info is updated"
	)
