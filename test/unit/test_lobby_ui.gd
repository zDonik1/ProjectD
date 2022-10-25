extends UnitTest


class LobbyUIEnv:
	extends UnitTest

	const LobbyUI := preload("res://scripts/lobby_ui.gd")
	const names := [
		"My first item", "This is a second item", "Here is a third one"
	]

	var lobby_ui: LobbyUI

	func before_each():
		.before_each()
		lobby_ui = partial_double("res://scenes/lobby_ui.tscn").instance()
		stub(lobby_ui, "_ready").to_call_super()


class LobbyUIEnvWithLobby:
	extends LobbyUIEnv

	var lobby: Lobby

	func before_each():
		.before_each()
		lobby = autofree(Lobby.new())
		lobby_ui.lobby = lobby
		add_child(lobby_ui)


class LobbyUIEnvWithSetNames:
	extends LobbyUIEnv

	func before_each():
		.before_each()
		lobby_ui.set_item_names(names)


class TestLobbyUI:
	extends LobbyUIEnv

	func test_setting_names_to_list_with_existing_items_overrides_it():
		lobby_ui.add_item("Some other item")

		lobby_ui.set_item_names(names)

		assert_eq(lobby_ui.get_item_names(), names)


class TestLobbyUIWithLobby:
	extends LobbyUIEnvWithLobby

	func test_add_player_receiver_connected_to_lobby_peer_added_on_ready():
		lobby.emit_signal("peer_added", TestUtils.get_player_info())

		assert_called(lobby_ui, "_add_player", [TestUtils.get_player_info()])

	func test_remove_player_receiver_connected_to_lobby_peer_removed_on_ready():
		var index = 2

		lobby.emit_signal("peer_removed", index)

		assert_called(lobby_ui, "_remove_player", [index])


class TestLobbyUIWithSetNames:
	extends LobbyUIEnvWithSetNames

	const new_name := "Some new player"

	func test_player_name_added_to_list_on_add_player():
		var all_names := names + [new_name]

		lobby_ui._add_player(Lobby.LobbyUtils.make_info_with_name(new_name))

		assert_eq(lobby_ui.get_item_names(), all_names)

	func test_player_name_removed_from_list_on_remove_player():
		var index = 1
		var all_names := names
		all_names.remove(index)

		lobby_ui._remove_player(index)

		assert_eq(lobby_ui.get_item_names(), all_names)
