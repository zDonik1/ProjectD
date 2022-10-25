extends GutTest


class CoordinatorEnv:
	extends UnitTest

	var coordinator: Coordinator

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


class TestCoordinatorWithMainMenu:
	extends CoordinatorEnvWithMainMenu

	func test_creates_connecting_message_as_sibling_when_main_menu_join_server_pressed_emits():
		$MainMenu.emit_signal("join_server_pressed")

		assert_true(
			has_node("ConnectingMessage"), "check ConnectingMessage was created"
		)


class TestCoordinatorWithMainMenuAndLobby:
	extends CoordinatorEnvWithMainMenu

	var lobby: Lobby

	func before_each():
		.before_each()
		lobby = double(Lobby).new()
		lobby.name = "Lobby"
		stub(lobby, "_ready").to_do_nothing()
		stub(lobby, "create_server").to_do_nothing()
		add_child(lobby)

	func test_creates_lobby_ui_as_sibling_when_main_menu_create_server_pressed_emits():
		$MainMenu.emit_signal("create_server_pressed")

		assert_true(has_node("LobbyUI"), "check LobbyUI was created")

	func test_initializes_lobby_ui_with_lobby_when_main_menu_create_server_pressed_emits():
		$MainMenu.emit_signal("create_server_pressed")

		assert_eq($LobbyUI.lobby, lobby)

	func test_calls_create_server_on_lobby_when_main_menu_create_server_pressed_emits():
		$MainMenu.emit_signal("create_server_pressed")

		assert_called(lobby, "create_server")
