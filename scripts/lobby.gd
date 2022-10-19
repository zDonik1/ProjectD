class_name Lobby extends Node

const DEFAULT_PORT = 65000
const MAX_CLIENTS = 3

var peer = null
var ip_address = "127.0.0.1"

var info = Utils.make_info_with_name("Player")
var players_info = []


class Utils:
	static func make_player_info_with_id(_id, _info):
		return {"id": _id, "info": _info}

	static func make_info_with_name(name):
		return {"name": name}


func create_server():
	_ensure_peer_exists()
	peer.create_server(DEFAULT_PORT, MAX_CLIENTS)
	get_tree().set_network_peer(peer)
	players_info = [
		Utils.make_player_info_with_id(get_tree().get_network_unique_id(), info)
	]


func join_server():
	_ensure_peer_exists()
	peer.create_client(ip_address, DEFAULT_PORT)
	get_tree().set_network_peer(peer)


func _ready():
	var _u
	_u = get_tree().connect(
		"network_peer_connected", self, "_network_peer_connected"
	)
	_u = get_tree().connect(
		"network_peer_disconnected", self, "_network_peer_disconnected"
	)
	_u = get_tree().connect("connected_to_server", self, "_connected_to_server")
	_u = get_tree().connect("server_disconnected", self, "_server_disconnected")
	_u = get_tree().connect("connection_failed", self, "_connection_failed")


func _ensure_peer_exists():
	if peer == null:
		peer = _make_peer()


func _make_peer():
	return NetworkedMultiplayerENet.new()


func _network_peer_connected(id):
	print("Peer connected with id ", id)
	rpc_id(id, "_register_new_player", info)


func _network_peer_disconnected(id):
	print("Peer disconnected with id ", id)


func _connected_to_server():
	print("Successfully connected to server")
	_register_player(get_tree().get_network_unique_id(), info)


func _connection_failed():
	print("Connection failed")


func _server_disconnected():
	print("Disconnected from the server")


func _on_LineEdit_text_changed(new_text):
	ip_address = new_text


remote func _register_new_player(_info):
	print("New player registered ", get_tree().get_rpc_sender_id())
	_register_player(get_tree().get_rpc_sender_id(), _info)


func _register_player(id, _info):
	players_info.append(Utils.make_player_info_with_id(id, _info))
