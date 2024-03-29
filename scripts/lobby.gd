class_name Lobby
extends Node

signal peer_added(info)
signal peer_removed(index)
signal peers_cleared

const DEFAULT_PORT = 65000
const MAX_CLIENTS = 3

var peer: ENetMultiplayerPeer

var info = LobbyUtils.make_info_with_name("Player")
var players_info := []

var _server_advertiser: ServerAdvertiser


class LobbyUtils:
	static func make_player_info_with_id(_id, _info) -> Dictionary:
		return {"id": _id, "info": _info}

	static func make_info_with_name(name):
		return {"name": name}


func _ready():
	var _u
	_u = multiplayer.connect(
		"peer_connected", self, "_network_peer_connected"
	)
	_u = multiplayer.connect(
		"peer_disconnected", self, "_network_peer_disconnected"
	)
	_u = multiplayer.connect(
		"connected_to_server", self, "_connected_to_server"
	)
	_u = multiplayer.connect(
		"server_disconnected", self, "_server_disconnected"
	)
	_u = multiplayer.connect("connection_failed",Callable(self,"_connection_failed"))


func _notification(what):
	match what:
		NOTIFICATION_PREDELETE:
			disconnect_from_network()


func create_server():
	_ensure_peer_exists()
	get_tree().refuse_new_connections = false
	var _u := peer.create_server(DEFAULT_PORT, MAX_CLIENTS)
	multiplayer.set_multiplayer_peer(peer)
	call_deferred("_register_self")


func join_server(ip_address: String):
	_ensure_peer_exists()
	var _u := peer.create_client(ip_address, DEFAULT_PORT)
	multiplayer.set_multiplayer_peer(peer)


func finish_search():
	get_tree().refuse_new_connections = true


func disconnect_from_network():
	Logger.info("Closing network connection", "Lobby")
	if peer:
		peer.close_connection()
		peer = null
	_clear_player_list()


func _ensure_peer_exists():
	if peer == null:
		peer = _make_peer()


func _make_peer() -> ENetMultiplayerPeer:
	return ENetMultiplayerPeer.new()


func _network_peer_connected(id):
	Logger.info("Peer connected with id {}".format([id], "{}"), "Lobby")
	rpc_id(id, "_register_new_player", info)


func _network_peer_disconnected(id):
	Logger.info("Peer disconnected with id {}".format([id], "{}"), "Lobby")
	var index := _get_index_of_player(id)
	players_info.remove(index)
	emit_signal("peer_removed", index)


func _connected_to_server():
	Logger.info("Successfully connected to server", "Lobby")
	_register_self()


func _connection_failed():
	Logger.info("Connection failed", "Lobby")


func _server_disconnected():
	Logger.info("Disconnected from the server", "Lobby")
	_clear_player_list()


@rpc("any_peer") func _register_new_player(_info: Dictionary):
	_register_player(multiplayer.get_remote_sender_id(), _info)


func _register_self():
	_register_player(multiplayer.get_unique_id(), info)


func _register_player(id: int, _info: Dictionary):
	var player_info := LobbyUtils.make_player_info_with_id(id, _info)
	players_info.append(player_info)
	Logger.debug("Registered player {0}".format([player_info]))
	emit_signal("peer_added", _info)


func _clear_player_list():
	players_info.clear()
	emit_signal("peers_cleared")


func _get_index_of_player(id: int) -> int:
	for index in range(players_info.size()):
		if players_info[index].id == id:
			return index
	return -1
