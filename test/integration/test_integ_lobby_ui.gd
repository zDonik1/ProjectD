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

	await yield_for(0.5).YIELD

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

func test_clients_dont_have_start_game_button():
	var _server_main := instantiate_server_with_name("Server")
	var client_main := instantiate_client_with_name("Client")

	await yield_for(0.1).YIELD
	
	assert_false(
		client_main.get_node("LobbyUI").has_node("StartGame"), 
		"check client doesn't have StartGame button"
	)


func test_transitions_to_game_scene_when_server_starts_game():
	var server_main := instantiate_server_with_name("Server")
	var client_main := instantiate_client_with_name("Client")

	await yield_for(0.1).YIELD

	server_main.get_node("LobbyUI/StartGame").emit_signal("pressed")

	await yield_for(0.1).YIELD

	assert_true(server_main.has_node("Game"), "check server transitioned to Game scene")
	assert_true(client_main.has_node("Game"), "check client transitioned to Game scene")

	assert_false(server_main.has_node("MainMenu"), "check that MainMenu was removed")
	assert_false(server_main.has_node("LobbyUI"), "check that LobbyUI was removed")

	