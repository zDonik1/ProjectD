class_name FakeNetworkMultiplayerENet extends NetworkedMultiplayerCustom


func create_client(_ip_address, _port):
	_status_connected()


func create_server(_port, _max_clients):
	_status_connected()


func _status_connected():
	set_connection_status(NetworkedMultiplayerPeer.CONNECTION_CONNECTING)
	set_connection_status(NetworkedMultiplayerPeer.CONNECTION_CONNECTED)
