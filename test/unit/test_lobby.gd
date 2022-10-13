extends GutTest

func test_create_server_calls_set_network_peer_on_scene_tree():
	var lobby = partial_double('res://scripts/lobby.gd').new()
	var scene_tree = double('res://test/mock/mock_scene_tree.gd').new()
	stub(lobby, 'get_tree').to_return(scene_tree)
	stub(scene_tree, 'set_network_peer')

	lobby.create_server()

	assert_called(scene_tree, 'set_network_peer')
