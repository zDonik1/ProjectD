extends IntegTest


func test_all_peers_show_up_in_list_after_connecting():
	var names := {
		server = "Server",
		client1 = "Client 1",
		client2 = "Client 2",
	}

	var server_main := instantiate_server_with_name(names.server)
	var client1_main := instantiate_client_with_name(names.client1)
	var client2_main := instantiate_client_with_name(names.client2)

	yield(yield_for(0.5), YIELD)

	assert_true(
		TestUtils.is_array_similar(
			server_main.get_node("LobbyUI").get_item_names(), 
			names.values()
		), 
		"check server lobbyui names are updated"
	)

	assert_true(
		TestUtils.is_array_similar(
			client1_main.get_node("LobbyUI").get_item_names(), 
			names.values()
		), 
		"check client 1 lobbyui names are updated"
	)

	assert_true(
		TestUtils.is_array_similar(
			client2_main.get_node("LobbyUI").get_item_names(), 
			names.values()
		), 
		"check client 2 lobbyui names are updated"
	)