extends Node

var _client = WebSocketClient.new()
var _write_mode = WebSocketPeer.WRITE_MODE_BINARY

func _init():
	_client.connect("connection_established", self, "_client_connected")
	_client.connect("connection_error", self, "_client_disconnected")
	_client.connect("connection_closed", self, "_client_disconnected")
	_client.connect("server_close_request", self, "_client_close_request")
	_client.connect("data_received", self, "_client_received")
	
	connect_to_url("ws://127.0.0.1:9080")
	
func _client_connected(protocol):
	Utils._log("Client just connected with protocol: %s" % [protocol])
	_client.get_peer(1).set_write_mode(_write_mode)
	
func _client_disconnected(clean=true):
	Utils._log("Client just disconnected. Was clean: %s" % clean)
	
func _client_close_request(code,reason):
	Utils._log("Close code: %d, reason: %s" % [code, reason])
	
func _client_received():
	var packet = _client.get_peer(1).get_packet()
	Utils._log("Received data: %s" % [Utils.decode_data(packet)])

func _exit_tree():
	_client.disconnect_from_host(1001, "Bye bye!")
	
func _process(_delta):
	if _client.get_connection_status() == WebSocketClient.CONNECTION_DISCONNECTED:
		return
		
	_client.poll()

func connect_to_url(host):
	return _client.connect_to_url(host)

func disconnect_from_host():
	_client.disconnect_from_host(1000, "Bye bye!")
	
func send_data(data):
	_client.get_peer(1).set_write_mode(_write_mode)
	_client.get_peer(1).put_packet(Utils.encode_data(data))

func set_write_mode(mode):
	_write_mode = mode
