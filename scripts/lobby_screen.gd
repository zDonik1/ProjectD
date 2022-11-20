class_name LobbyScreen
extends Control

signal back_pressed

onready var _player_list: ItemList = $PlayerList


func get_item_names():
	var result := []
	for i in range(_player_list.get_item_count()):
		result.append(_player_list.get_item_text(i))
	return result


func set_item_names(names: Array):
	_player_list.clear()
	for name in names:
		_add_non_selectable_name(name)


func _add_non_selectable_name(name: String):
	_player_list.add_item(name, null, false)


func _on_Lobby_peer_added(info: Dictionary):
	_add_non_selectable_name(info.name)


func _on_Lobby_peer_removed(index: int):
	_player_list.remove_item(index)


func _on_Back_pressed():
	emit_signal("back_pressed")
