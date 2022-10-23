class_name FakeNetworkMultiplayerENet extends NetworkedMultiplayerCustom

var self_id = 0


func create_client(
	_ip_address, _port, _in_bandwidth = 0, _out_bandwidth = 0, _client_port = 0
):
	status_connected()


func create_server(
	_port, _max_clients = 32, _in_bandwidth = 0, _out_bandwidth = 0
):
	status_connected()


func status_connected():
	set_connection_status(NetworkedMultiplayerPeer.CONNECTION_CONNECTING)
	initialize(self_id)
	set_connection_status(NetworkedMultiplayerPeer.CONNECTION_CONNECTED)
