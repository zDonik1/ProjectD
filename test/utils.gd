class_name TestUtils

class FakeMultiplayerAPI:
	extends MultiplayerAPI

	var sender_id

	func get_rpc_sender_id():
		return sender_id

var test
var multiplayer

var _st_props = {}
var _prop_blacklist = ["multiplayer", "refuse_new_network_connections"]
var _scene_tree
var _runner_node


func _init(test_instance):
	test = test_instance
	_scene_tree = test.get_tree()
	_runner_node = _scene_tree.root.get_child(0)

	for property in ClassDB.class_get_property_list("SceneTree", true):
		if not _prop_blacklist.has(property.name):
			_st_props[property.name] = ClassDB.class_get_property(
				_scene_tree, property.name
			)


func initialize_scene_tree_state():
	multiplayer = test.autofree(FakeMultiplayerAPI.new())
	multiplayer.root_node = _runner_node
	
	for property in _st_props.keys():
		if not _prop_blacklist.has(property):
			var _u = ClassDB.class_set_property(
				_scene_tree, property, _st_props[property]
			)


static func get_player_info():
	return Lobby.Utils.make_info_with_name("Some player name")


static func get_players_info():
	return [
		Lobby.Utils.make_player_info_with_id(
			1, Lobby.Utils.make_info_with_name("Player 1")
		),
		Lobby.Utils.make_player_info_with_id(
			2, Lobby.Utils.make_info_with_name("Player 2")
		)
	]


static func make_lobby(tst_inst):
	var lobby = make_free_lobby(tst_inst)
	tst_inst.add_child(lobby)
	return lobby


static func make_free_lobby(tst_inst):
	var lobby = tst_inst.autofree(Lobby.new())
	lobby.name = "Lobby"
	return lobby


static func is_array_similar(actual_arr, expected_arr):
	for elem in expected_arr:
		var found = false
		for act_elem in actual_arr:
			if elem.hash() == act_elem.hash():
				found = true

		if not found:
			return false

	return true
