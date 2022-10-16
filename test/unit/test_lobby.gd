extends GutTest


class Utils:
	static func make_lobby(tst_inst):
		var lobby = tst_inst.partial_double("res://scripts/lobby.gd", tst_inst.DOUBLE_STRATEGY.FULL).new()
		tst_inst.stub(lobby, "_ready").to_call_super()
		tst_inst.add_child(lobby)
		return lobby


const PLAYER_NAME = "Some player name"

var lobby

var network_connection_params = ParameterFactory.named_parameters(
	["signal", "receiver"],
	[
		["network_peer_connected", "_network_peer_connected"],
		["network_peer_disconnected", "_network_peer_disconnected"],
		["connected_to_server", "_connected_to_server"],
		["server_disconnected", "_server_disconnected"],
		["connection_failed", "_connection_failed"],
	]
)


func before_each():
	lobby = Utils.make_lobby(self)


func test_appropriate_receiver_called_when_network_signal_emitted_on_scene_tree(
	params = use_parameters(network_connection_params)
):
	stub(lobby, params.receiver).to_do_nothing()

	get_tree().emit_signal(params.signal)

	assert_called(lobby, params.receiver)


func test_peer_not_initialized_by_default():
	assert_eq(lobby.peer, null)


func test_player_name_not_initialized_by_default():
	assert_eq(lobby.player_name, null)


func test_player_name_initialized_to_player_0_after_creating_server():
	lobby.create_server()

	assert_eq(lobby.player_name, "Player 0")


func test_player_name_not_changed_after_creating_server_when_initialized():
	lobby.player_name = PLAYER_NAME

	lobby.create_server()

	assert_eq(lobby.player_name, PLAYER_NAME)


func test_has_peer_after_joining_server():
	lobby.join_server()

	assert_true(get_tree().has_network_peer())


func test_on_LineEdit_text_changed_sets_ip_address():
	var text = "some text here"

	lobby._on_LineEdit_text_changed(text)

	assert_eq(lobby.ip_address, text)


class TestLobbyWithMockPeer:
	extends GutTest

	var lobby
	var peer

	func before_each():
		lobby = Utils.make_lobby(self)
		peer = partial_double(NetworkedMultiplayerENet).new()
		lobby.peer = peer

	func test_create_server_sets_server_network_peer_on_scene_tree():
		lobby.create_server()

		assert_called(
			peer, "create_server", [lobby.DEFAULT_PORT, lobby.MAX_CLIENTS, 0, 0]
		)
		assert_true(get_tree().is_network_server())

	func test_join_server_sets_client_network_peer_on_scene_tree():
		lobby.join_server()

		assert_called(
			peer,
			"create_client",
			[lobby.ip_address, lobby.DEFAULT_PORT, 0, 0, 0]
		)
		assert_false(get_tree().is_network_server())


class TestRpcCalls:
	extends GutTest
	
	const LOBBY_PATH = "res://scripts/lobby.gd"
	const PLAYER_NAME = "Some player 123"

	func test_rpc_register_player_called_with_player_name_when_peer_connects():
		stub(LOBBY_PATH, "rpc_id").to_do_nothing().param_count(3)

		var lobby = partial_double(LOBBY_PATH, DOUBLE_STRATEGY.FULL).new()
		stub(lobby, "_ready").to_call_super()
		add_child(lobby)
		lobby.player_name = PLAYER_NAME

		lobby._network_peer_connected(10)

		assert_called(
			lobby, "rpc_id", [10, "_register_player", PLAYER_NAME]
		)
