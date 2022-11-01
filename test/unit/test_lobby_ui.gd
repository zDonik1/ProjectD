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


class LobbyUIEnvWithLobbyAndSetNames:
	extends LobbyUIEnv

	var lobby: Lobby

	func before_each():
		.before_each()
		lobby_ui.set_item_names(names)

		lobby = autofree(Lobby.new())
		lobby_ui.lobby = lobby
		add_child(lobby_ui)


class TestLobbyUI:
	extends LobbyUIEnv

	func test_setting_names_to_list_with_existing_items_overrides_it():
		lobby_ui.add_item("Some other item")

		lobby_ui.set_item_names(names)

		assert_eq(lobby_ui.get_item_names(), names)


class TestLobbyUIWithLobbyAndSetNames:
	extends LobbyUIEnvWithLobbyAndSetNames

	func test_player_name_added_when_lobby_peer_added_emitted():
		var new_name := "Some new player"
		var all_names := names + [new_name]

		lobby.emit_signal(
			"peer_added", Lobby.LobbyUtils.make_info_with_name(new_name)
		)

		print(lobby_ui.get_item_names())
		print(all_names)
		assert_eq(lobby_ui.get_item_names(), all_names)

	func test_player_name_removed_when_lobby_peer_removed_emitted():
		var index = 1
		var all_names := names.duplicate()
		all_names.remove(index)

		lobby.emit_signal("peer_removed", index)
		
		assert_eq(lobby_ui.get_item_names(), all_names)
