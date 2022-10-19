class_name FakeSceneTree extends Node

onready var root = Node.new()  # viewport root
var peer
var id
var rpc_sender_id

signal network_peer_connected(id)
signal network_peer_disconnected(id)
signal connected_to_server
signal server_disconnected
signal connection_failed


func get_root():
	return root


func set_network_peer(_peer):
	peer = _peer


func has_network_peer():
	return peer != null


func get_network_unique_id():
	return id


func get_rpc_sender_id():
	return rpc_sender_id


func _ready():
	add_child(root)
