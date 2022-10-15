extends GutTest


class Utils:
	static func make_lobby(tst_inst):
		var lobby = tst_inst.partial_double("res://scripts/lobby.gd", tst_inst.DOUBLE_STRATEGY.FULL).new()
		tst_inst.stub(lobby, "_ready").to_call_super()
		return lobby


var lobby

var network_client_connection_params = ParameterFactory.named_parameters(
	["signal", "receiver"],
	[
		["connected_to_server", "_connected_to_server"],
		["server_disconnected", "_server_disconnected"],
		["connection_failed", "_connection_failed"],
	]
)


func before_each():
	lobby = Utils.make_lobby(self)


func test_appropriate_receiver_called_when_client_signal_emitted_on_scene_tree(
	params = use_parameters(network_client_connection_params)
):
	stub(lobby, params.receiver)
	add_child(lobby)

	get_tree().emit_signal(params.signal)

	assert_called(lobby, params.receiver)


func test_create_server_sets_server_network_peer_on_scene_tree():
	var peer = partial_double(NetworkedMultiplayerENet).new()
	lobby.peer = peer
	add_child(lobby)

	lobby.create_server()

	assert_called(
		peer, "create_server", [lobby.DEFAULT_PORT, lobby.MAX_CLIENTS, 0, 0]
	)
	assert_true(get_tree().has_network_peer())
	assert_true(get_tree().is_network_server())


func test_peer_not_initialized_by_default():
	assert_eq(lobby.peer, null)
