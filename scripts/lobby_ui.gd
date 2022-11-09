extends Control

var lobby: Lobby

var _player_list: ItemList


func _ready():
	var _u: int
	_u = lobby.connect("peer_added", self, "_add_player")
	_u = lobby.connect("peer_removed", self, "_remove_player")

	_player_list = $PlayerList


func get_item_names():
	var result := []
	for i in range(_player_list.get_item_count()):
		result.append(_player_list.get_item_text(i))
	return result


func set_item_names(names: Array):
	_player_list.clear()
	for name in names:
		_add_non_selectable_name(name)


func _add_player(info: Dictionary):
	_add_non_selectable_name(info.name)


func _remove_player(index: int):
	_player_list.remove_item(index)


func _add_non_selectable_name(name: String):
	_player_list.add_item(name, null, false)
