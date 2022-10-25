extends GutTest


class CoordinatorEnv:
	extends UnitTest

	var coordinator: Node

	func before_each():
		coordinator = add_child_autofree(Coordinator.new())

	func after_each():
		free_node_if_exists("MainMenu")
		free_node_if_exists("LobbyUI")
		free_node_if_exists("ConnectingMessage")


class CoordinatorEnvWithMainMenu:
	extends CoordinatorEnv

	func before_each():
		.before_each()
		coordinator.add_main_menu()


class TestCoordinator:
	extends CoordinatorEnv

	func test_creates_main_menu_as_sibling_on_add_main_menu():
		coordinator.add_main_menu()

		assert_true(has_node("MainMenu"), "check MainMenu was created")

	func test_initializes_main_menu_coordinator_with_self_on_add_main_menu():
		coordinator.add_main_menu()

		assert_eq($MainMenu.coordinator, coordinator)


class TestCoordinatorWithLobbyUI:
	extends CoordinatorEnvWithMainMenu

	var lobby: Node

	func before_each():
		.before_each()
		lobby = add_child_autofree(Lobby.new())
		lobby.name = "Lobby"

	func test_creates_lobby_ui_as_sibling_when_main_menu_create_server_pressed_emits():
		$MainMenu.emit_signal("create_server_pressed")

		assert_true(has_node("LobbyUI"), "check LobbyUI was created")

	func test_initializes_lobby_ui_with_lobby():
		$MainMenu.emit_signal("create_server_pressed")

		assert_eq($LobbyUI.lobby, lobby)


class TestCoordinatorWithConnectingMessage:
	extends CoordinatorEnvWithMainMenu

	func test_creates_connecting_message_as_sibling_when_main_menu_join_server_pressed_emits():
		$MainMenu.emit_signal("join_server_pressed")

		assert_true(
			has_node("ConnectingMessage"), "check ConnectingMessage was created"
		)
