class_name Lobby
extends Node

signal peer_added(info)
signal peer_removed(index)

const DEFAULT_PORT = 65000
const MAX_CLIENTS = 3

var peer = null
var ip_address = "127.0.0.1"

var info = LobbyUtils.make_info_with_name("Player")
var players_info = []


class LobbyUtils:
	static func make_player_info_with_id(_id, _info):
		return {"id": _id, "info": _info}

	static func make_info_with_name(name):
		return {"name": name}


func create_server():
	_ensure_peer_exists()
	peer.create_server(DEFAULT_PORT, MAX_CLIENTS)
	multiplayer.set_network_peer(peer)
	call_deferred("_register_self")


func join_server():
	_ensure_peer_exists()
	peer.create_client(ip_address, DEFAULT_PORT)
	multiplayer.set_network_peer(peer)


func _ready():
	var _u
	_u = multiplayer.connect(
		"network_peer_connected", self, "_network_peer_connected"
	)
	_u = multiplayer.connect(
		"network_peer_disconnected", self, "_network_peer_disconnected"
	)
	_u = multiplayer.connect(
		"connected_to_server", self, "_connected_to_server"
	)
	_u = multiplayer.connect(
		"server_disconnected", self, "_server_disconnected"
	)
	_u = multiplayer.connect("connection_failed", self, "_connection_failed")


func _ensure_peer_exists():
	if peer == null:
		peer = _make_peer()


func _make_peer():
	return NetworkedMultiplayerENet.new()


func _network_peer_connected(id):
	Logger.info("Peer connected with id {}".format([id], "{}"), "Lobby")
	rpc_id(id, "_register_new_player", info)


func _network_peer_disconnected(id):
	Logger.info("Peer disconnected with id {}".format([id], "{}"), "Lobby")
	emit_signal("peer_removed", _get_index_of_player(id))


func _connected_to_server():
	Logger.info("Successfully connected to server", "Lobby")
	_register_self()


func _connection_failed():
	Logger.info("Connection failed", "Lobby")


func _server_disconnected():
	Logger.info("Disconnected from the server", "Lobby")


remote func _register_new_player(_info: Dictionary):
	_register_player(multiplayer.get_rpc_sender_id(), _info)


func _register_self():
	_register_player(multiplayer.get_network_unique_id(), info)


func _register_player(id: int, _info: Dictionary):
	players_info.append(LobbyUtils.make_player_info_with_id(id, _info))
	emit_signal("peer_added", _info)


func _get_index_of_player(id):
	for index in range(players_info.size()):
		if players_info[index].id == id:
			return index
	return -1
