class_name UnitTest extends GutTest


class FakeMultiplayerAPI:
	extends MultiplayerAPI

	var sender_id

	func get_rpc_sender_id():
		return sender_id


var multiplayer_inst

var _scene_tree
var _runner_node


func before_all():
	_scene_tree = get_tree()
	_runner_node = _scene_tree.root.get_child(0)


func before_each():
	multiplayer_inst = autofree(FakeMultiplayerAPI.new())
	multiplayer_inst.root_node = _runner_node
