extends GutTest


class Utils:
	static func make_lobby(tst_inst):
		var lobby = tst_inst.partial_double("res://scripts/lobby.gd", tst_inst.DOUBLE_STRATEGY.FULL).new()
		tst_inst.stub(lobby, "_ready").to_call_super()
		return lobby


var lobby


func before_each():
	lobby = Utils.make_lobby(self)


var network_client_connection_params = ParameterFactory.named_parameters(
	["signal", "receiver"],
	[
		["connected_to_server", "_connected_to_server"],
		["server_disconnected", "_server_disconnected"],
		["connection_failed", "_connection_failed"],
	]
)


func test_appropriate_receiver_called_when_client_signal_emitted_on_scene_tree(
	params = use_parameters(network_client_connection_params)
):
	stub(lobby, params.receiver)
	add_child(lobby)

	get_tree().emit_signal(params.signal)

	assert_called(lobby, params.receiver)


func test_create_server_calls_set_network_peer_on_scene_tree():
	var scene_tree = double("res://test/mock/mock_scene_tree.gd").new()
	stub(lobby, "get_tree").to_return(scene_tree)
	stub(scene_tree, "set_network_peer")

	lobby.create_server()

	assert_called(scene_tree, "set_network_peer")
