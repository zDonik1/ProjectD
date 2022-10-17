extends GutTest


class Utils:
	static func make_doubled_lobby(tst_inst):
		var lobby = tst_inst.partial_double(TestUtils.get_lobby_path(), tst_inst.DOUBLE_STRATEGY.FULL).new()
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


func test_info_name_initialized_to_Player():
	assert_eq(lobby.info["name"], "Player")


func test_has_peer_after_joining_server():
	lobby.join_server()

	assert_true(get_tree().has_network_peer())


func test_on_LineEdit_text_changed_sets_ip_address():
	var text = "some text here"

	lobby._on_LineEdit_text_changed(text)

	assert_eq(lobby.ip_address, text)


func test_register_new_player_adds_player_info_to_players_info():
	lobby._register_new_player(TestUtils.get_player_info())

	assert_eq_deep(lobby.players_info, [TestUtils.get_player_info()])


func test_register_all_players_sets_players_info():
	lobby._register_all_players(TestUtils.get_players_info())

	assert_eq_deep(lobby.players_info, TestUtils.get_players_info())


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

	const PLAYER_NAME = "Some player 123"

	var lobby
	var scene_tree

	func before_each():
		stub(TestUtils.get_lobby_path(), "rpc").to_do_nothing().param_count(2)
		stub(TestUtils.get_lobby_path(), "rpc_id").to_do_nothing().param_count(
			3
		)
		lobby = Utils.make_lobby(self)
		scene_tree = double("res://test/mock/mock_scene_tree.gd").new()
		stub(lobby, "get_tree").to_return(scene_tree)

	func test_rpc_register_new_player_by_player_to_players_when_connected_to_server():
		lobby.info = TestUtils.get_player_info()

		lobby._connected_to_server()

		assert_called(
			lobby, "rpc", ["_register_new_player", TestUtils.get_player_info()]
		)

	func test_players_info_has_self_info_after_connecting_to_server():
		var id = 10
		stub(scene_tree, "get_network_unique_id").to_return(id)
		stub(lobby, "get_tree").to_return(scene_tree)

		lobby._connected_to_server()

		assert_eq_deep(
			lobby.players_info, [{"id": id, "info": {"name": "Player"}}]
		)

	func test_rpc_register_all_players_by_server_to_player_when_network_peer_connected():
		var id = 10
		lobby.players_info = TestUtils.get_players_info()
		stub(scene_tree, "is_network_server").to_return(true)

		lobby._network_peer_connected(id)

		assert_called(
			lobby,
			"rpc_id",
			[id, "_register_all_players", TestUtils.get_players_info()]
		)

	func test_rpc_register_all_players_not_called_by_clients():
		var id = 10
		stub(scene_tree, "is_network_server").to_return(false)

		lobby._network_peer_connected(id)

		assert_not_called(lobby, "rpc_id")
