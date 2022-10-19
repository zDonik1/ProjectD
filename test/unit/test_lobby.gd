extends GutTest


class Utils:
	static func make_lobby(tst_inst):
		var scene_tree = tst_inst.partial_double(FakeSceneTree, tst_inst.DOUBLE_STRATEGY.FULL).new()
		tst_inst.stub(scene_tree, "_ready").to_call_super()
		tst_inst.add_child(scene_tree)

		var lobby = _make_lobby(tst_inst)
		tst_inst.stub(lobby, "get_tree").to_return(scene_tree)
		scene_tree.get_root().add_child(lobby)

		return {"scene_tree": scene_tree, "lobby": lobby}

	static func _make_lobby(tst_inst):
		var lobby = tst_inst.partial_double(Lobby, tst_inst.DOUBLE_STRATEGY.FULL).new()
		tst_inst.stub(lobby, "_ready").to_call_super()
		tst_inst.stub(lobby, "_make_peer").to_return(
			FakeNetworkMultiplayerENet.new()
		)
		return lobby


const PLAYER_NAME = "Some player name"

var scene_tree
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
	var env = Utils.make_lobby(self)
	scene_tree = env.scene_tree
	lobby = env.lobby


func test_appropriate_receiver_called_when_network_signal_emitted_on_scene_tree(
	params = use_parameters(network_connection_params)
):
	stub(lobby, params.receiver).to_do_nothing()

	lobby.get_tree().emit_signal(params.signal)

	assert_called(lobby, params.receiver)


func test_peer_not_initialized_by_default():
	assert_eq(lobby.peer, null)


func test_info_name_initialized_to_Player():
	assert_eq(lobby.info["name"], "Player")


func test_has_peer_after_joining_server():
	lobby.join_server()

	assert_true(lobby.get_tree().has_network_peer())


func test_creating_server_intializes_players_info_with_self_info():
	lobby.create_server()

	assert_eq_deep(
		lobby.players_info,
		[
			{
				"id": lobby.get_tree().get_network_unique_id(),
				"info": lobby.info,
			}
		]
	)


func test_on_LineEdit_text_changed_sets_ip_address():
	var text = "some text here"

	lobby._on_LineEdit_text_changed(text)

	assert_eq(lobby.ip_address, text)


func test_players_info_has_self_info_after_connecting_to_server():
	var id = 10
	stub(lobby.get_tree(), "get_network_unique_id").to_return(id)

	lobby._connected_to_server()

	assert_eq_deep(
		lobby.players_info,
		[
			Lobby.Utils.make_player_info_with_id(
				id, Lobby.Utils.make_info_with_name("Player")
			)
		]
	)


func test_register_new_player_adds_self_info_to_players_info():
	scene_tree.rpc_sender_id = 10

	lobby._register_new_player(TestUtils.get_player_info())

	assert_eq_deep(
		lobby.players_info,
		[
			Lobby.Utils.make_player_info_with_id(
				scene_tree.rpc_sender_id, TestUtils.get_player_info()
			)
		]
	)


class TestLobbyWithMockPeer:
	extends GutTest

	var lobby
	var peer

	func before_each():
		lobby = Utils.make_lobby(self).lobby
		peer = double(NetworkedMultiplayerENet).new()
		lobby.peer = peer

	func test_create_server_sets_server_network_peer_on_scene_tree():
		lobby.create_server()

		assert_called(
			peer, "create_server", [lobby.DEFAULT_PORT, lobby.MAX_CLIENTS, 0, 0]
		)

	func test_join_server_sets_client_network_peer_on_scene_tree():
		lobby.join_server()

		assert_called(
			peer,
			"create_client",
			[lobby.ip_address, lobby.DEFAULT_PORT, 0, 0, 0]
		)


class TestLobbyWithRpcCalls:
	extends GutTest

	const PLAYER_NAME = "Some player 123"

	var lobby

	func before_each():
		stub(Lobby, "rpc_id").to_do_nothing().param_count(3)
		lobby = Utils.make_lobby(self).lobby

	func test_rpc_register_new_player_by_player_to_connected_player_when_peer_connected():
		var id = 15
		lobby.info = TestUtils.get_player_info()

		lobby._network_peer_connected(id)

		assert_called(
			lobby,
			"rpc_id",
			[id, "_register_new_player", TestUtils.get_player_info()]
		)
