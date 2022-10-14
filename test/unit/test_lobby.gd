extends GutTest

var lobby


func before_each():
	lobby = partial_double("res://scripts/lobby.gd", DOUBLE_STRATEGY.FULL).new()


func test_connected_to_server_receiver_called_when_scene_tree_signal_emitted():
	stub(lobby, "_ready").to_call_super()
	stub(lobby, "_connected_to_server")
	add_child(lobby)

	get_tree().emit_signal("connected_to_server")

	assert_called(lobby, "_connected_to_server")


func test_create_server_calls_set_network_peer_on_scene_tree():
	var scene_tree = double("res://test/mock/mock_scene_tree.gd").new()
	stub(lobby, "get_tree").to_return(scene_tree)
	stub(scene_tree, "set_network_peer")

	lobby.create_server()

	assert_called(scene_tree, "set_network_peer")
