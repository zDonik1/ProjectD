extends Control

signal join_server_pressed(ip)
signal back_pressed

@export var _server_list_path: NodePath

@onready var _server_list := get_node(_server_list_path) as ItemList

var _server_infos := []
var _selected_server_index: int


func _on_ServerList_item_selected(_index: int):
	$JoinServer.disabled = false
	_selected_server_index = _index


func _on_ServerList_nothing_selected():
	$JoinServer.disabled = true


func _on_ServerListener_new_server(game_info: Dictionary):
	_server_infos.append(game_info)
	_server_list.add_item(game_info.name, null, false)


func _on_ServerListener_remove_server(server_ip: String):
	_server_list.remove_item(_server_infos.find(server_ip))


func _on_JoinServer_pressed():
	emit_signal("join_server_pressed", _server_infos[_selected_server_index].ip)


func _on_Back_pressed():
	emit_signal("back_pressed")
