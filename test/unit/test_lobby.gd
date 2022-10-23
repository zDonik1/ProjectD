extends GutTest

func before_all():
	Logger.set_logger_level(Logger.LOG_LEVEL_WARN)


class LobbyEnv:
	extends UnitTest

	var lobby

	func before_each():
		.before_each()
		lobby = partial_double(Lobby, DOUBLE_STRATEGY.FULL).new()
		stub(lobby, "_ready").to_call_super()
		stub(lobby, "_make_peer").to_return(FakeNetworkMultiplayerENet.new())
		lobby.custom_multiplayer = multiplayer_inst
		add_child(lobby)


class LobbyEnvWithPeer:
	extends LobbyEnv

	var peer

	func before_each():
		.before_each()
		peer = partial_double(FakeNetworkMultiplayerENet).new()
		lobby.peer = peer


class LobbyEnvWithConnectedPeer:
	extends LobbyEnvWithPeer

	var self_id = 123

	func before_each():
		.before_each()
		peer.self_id = self_id
		peer.status_connected()
		multiplayer_inst.network_peer = peer


class TestLobby:
	extends LobbyEnv

	func test_peer_not_initialized_by_default():
		assert_eq(lobby.peer, null)

	func test_info_name_initialized_to_Player():
		assert_eq(lobby.info["name"], "Player")

	func test_has_peer_after_joining_server():
		lobby.join_server()

		assert_true(lobby.multiplayer.has_network_peer())

	func test_creating_server_intializes_players_info_with_self_info():
		lobby.create_server()

		assert_eq_deep(
			lobby.players_info,
			[
				{
					"id": lobby.multiplayer.get_network_unique_id(),
					"info": lobby.info,
				}
			]
		)

	func test_on_LineEdit_text_changed_sets_ip_address():
		var text = "some text here"

		lobby._on_LineEdit_text_changed(text)

		assert_eq(lobby.ip_address, text)


class TestLobbyReceivers:
	extends LobbyEnv

	var network_connection_params = ParameterFactory.named_parameters(
		["signal", "receiver"],
		[
			["network_peer_connected", "_network_peer_connected"],
			["network_peer_disconnected", "_network_peer_disconnected"],
		]
	)

	var client_connection_params = ParameterFactory.named_parameters(
		["signal", "receiver"],
		[
			["connected_to_server", "_connected_to_server"],
			["server_disconnected", "_server_disconnected"],
			["connection_failed", "_connection_failed"],
		]
	)

	func test_appropriate_receiver_called_when_network_signal_emitted_on_scene_tree(
		params = use_parameters(network_connection_params)
	):
		var id = 10
		stub(lobby, params.receiver).to_do_nothing()

		lobby.multiplayer.emit_signal(params.signal, id)

		assert_called(lobby, params.receiver)

	func test_appropriate_receiver_called_when_client_signal_emitted_on_scene_tree(
		params = use_parameters(client_connection_params)
	):
		stub(lobby, params.receiver).to_do_nothing()

		lobby.multiplayer.emit_signal(params.signal)

		assert_called(lobby, params.receiver)


class TestLobbyWithDisconnectedPeer:
	extends LobbyEnvWithPeer	

	func test_create_server_sets_server_network_peer_on_scene_tree():
		lobby.create_server()

		assert_called(
			peer,
			"create_server",
			[lobby.DEFAULT_PORT, lobby.MAX_CLIENTS, null, null]
		)

	func test_join_server_sets_client_network_peer_on_scene_tree():
		lobby.join_server()

		assert_called(
			peer,
			"create_client",
			[lobby.ip_address, lobby.DEFAULT_PORT, null, null, null]
		)


class TestLobbyWithConnectedPeer:
	extends LobbyEnvWithConnectedPeer

	func test_players_info_has_self_info_after_connecting_to_server():
		lobby._connected_to_server()

		assert_eq_deep(
			lobby.players_info,
			[
				Lobby.LobbyUtils.make_player_info_with_id(
					self_id, Lobby.LobbyUtils.make_info_with_name("Player")
				)
			]
		)

	func test_register_new_player_adds_self_info_to_players_info():
		var sender_id = 186
		lobby.custom_multiplayer.sender_id = sender_id

		lobby._register_new_player(TestUtils.get_player_info())

		assert_eq_deep(
			lobby.players_info,
			[
				Lobby.LobbyUtils.make_player_info_with_id(
					sender_id, TestUtils.get_player_info()
				)
			]
		)


class TestLobbyWithRpcCalls:
	extends LobbyEnvWithConnectedPeer

	func before_each():
		stub(Lobby, "rpc_id").to_do_nothing().param_count(3)
		.before_each()

	func test_rpc_register_new_player_by_player_to_connected_player_when_peer_connected():
		var id = 15
		lobby.custom_multiplayer._add_peer(id)
		lobby.info = TestUtils.get_player_info()

		lobby._network_peer_connected(id)

		assert_called(
			lobby,
			"rpc_id",
			[id, "_register_new_player", TestUtils.get_player_info()]
		)
