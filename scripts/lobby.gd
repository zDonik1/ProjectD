extends Node

const DEFAULT_PORT = 65000
const MAX_CLIENTS = 3

var peer

var ip_address = "127.0.0.1"


func _ready():
	var _u
	_u = get_tree().connect("connected_to_server", self, "_connected_to_server")
	_u = get_tree().connect("server_disconnected", self, "_server_disconnected")
	_u = get_tree().connect("connection_failed", self, "_connection_failed")


func create_server():
	peer.create_server(DEFAULT_PORT, MAX_CLIENTS)
	get_tree().set_network_peer(peer)


func join_server():
	peer.create_client(ip_address, DEFAULT_PORT)
	get_tree().set_network_peer(peer)


func _connected_to_server():
	print("Successfully connected to the server")


func _connection_failed():
	print("Connection failed")


func _server_disconnected():
	print("Disconnected from the server")
	print(get_tree().get_network_peer())
	get_tree().set_network_peer(null)
	print(get_tree().get_network_peer())


func _on_LineEdit_text_changed(new_text):
	ip_address = new_text
