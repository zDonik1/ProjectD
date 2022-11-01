class_name UnitTest extends GutTest


class FakeMultiplayerAPI:
	extends MultiplayerAPI

	var sender_id

	func get_rpc_sender_id():
		return sender_id


var multiplayer_inst

var _runner_node


func before_all():
	_runner_node = get_tree().root.get_child(0)


func before_each():
	multiplayer_inst = autofree(FakeMultiplayerAPI.new())
	multiplayer_inst.root_node = _runner_node


########################
# ---- UTILITIES ----- #
########################


func free_node_if_exists(path: NodePath) -> void:
	if has_node(path):
		get_node(path).free()
