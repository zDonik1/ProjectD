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

	yield(yield_for(0.1), YIELD)

	assert_eq(server_main.get_node("LobbyUI").get_item_names(), names.values())
