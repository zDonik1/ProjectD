extends GutTest


class Utils:
	static func make_lobby(tst_inst):
		var lobby = tst_inst.partial_double("res://scripts/lobby.gd", tst_inst.DOUBLE_STRATEGY.FULL).new()
		tst_inst.stub(lobby, "_ready").to_call_super()
		return lobby


class TestInSceneTree:
	extends GutTest

	var lobby

	func before_each():
		lobby = Utils.make_lobby(self)

	func test_connected_to_server_receiver_called_when_scene_tree_signal_emitted():
		stub(lobby, "_connected_to_server")
		add_child(lobby)

		get_tree().emit_signal("connected_to_server")

		assert_called(lobby, "_connected_to_server")

	func test_server_disconnected_receiver_called_when_scene_tree_signal_emitted():
		stub(lobby, "_server_disconnected")
		add_child(lobby)

		get_tree().emit_signal("server_disconnected")

		assert_called(lobby, "_server_disconnected")


var lobby


func before_each():
	lobby = Utils.make_lobby(self)


func test_create_server_calls_set_network_peer_on_scene_tree():
	var scene_tree = double("res://test/mock/mock_scene_tree.gd").new()
	stub(lobby, "get_tree").to_return(scene_tree)
	stub(scene_tree, "set_network_peer")

	lobby.create_server()

	assert_called(scene_tree, "set_network_peer")
