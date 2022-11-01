extends IntegTest

const MainScene := preload("res://scenes/main.tscn")


func make_main_in_sub_st(sub_st: SubSceneTree) -> Node:
	var main = MainScene.instance()
	sub_st.st.root.add_child(main)
	return main


func make_main_with_player_name_and_call_signal_on_main(
	name: String, signal_name: String
) -> Node:
	var main := make_main_in_sub_st(add_sub_scene_tree_as_child())
	main.get_node("Lobby").info = Lobby.LobbyUtils.make_info_with_name(name)
	main.get_node("MainMenu").emit_signal(signal_name)
	return main


func instantiate_server_with_name(name: String) -> Node:
	return make_main_with_player_name_and_call_signal_on_main(
		name, "create_server_pressed"
	)


func instantiate_client_with_name(name: String) -> Node:
	return make_main_with_player_name_and_call_signal_on_main(
		name, "join_server_pressed"
	)


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
