extends Node
class_name ServerAdvertiser, 'res://addons/LANServerBroadcast/server_advertiser/server_advertiser.png'

const DEFAULT_PORT := 3111

@export var broadcast_interval: float: float = 1.0
var server_info := {"name": "LAN Game"}

var _socket_udp: PacketPeerUDP
var _broadcast_timer := Timer.new()


func _enter_tree():
	_broadcast_timer.wait_time = broadcast_interval
	_broadcast_timer.one_shot = false
	_broadcast_timer.autostart = true
	
	if get_tree().is_server():
		add_child(_broadcast_timer)
		_broadcast_timer.connect("timeout",Callable(self,"broadcast")) 
		
		_socket_udp = PacketPeerUDP.new()
		_socket_udp.set_broadcast_enabled(true)
		_socket_udp.set_dest_address('255.255.255.255', DEFAULT_PORT)


func broadcast():
	var packetMessage := JSON.new().stringify(server_info)
	var packet := packetMessage.to_ascii_buffer()
	_socket_udp.put_packet(packet)


func _exit_tree():
	_broadcast_timer.stop()
	if _socket_udp != null:
		_socket_udp.close()
