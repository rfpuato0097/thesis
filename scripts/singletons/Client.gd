extends Node

const IP_ADDRESS = "mindgames.southeastasia.cloudapp.azure.com"
const PORT = 443
var server_url = "wss://%s:%d" % [IP_ADDRESS, PORT]

var _client = WebSocketClient.new()
var _write_mode = WebSocketPeer.WRITE_MODE_BINARY

var created_lobbies = []
var lobby_id
var lobby_name = "XXXXX"
var evaluation_page = "XXXXX"
var questions = []
var words = []
var player_name
var score
var total
var correct_questions
var wrong_questions
var questions_for_gr
var game_score
var error_message = ""
var throw_error = false
var connected = false

#analytics
var player_count
var average_score
var difficult_questions
var students_low
var easy_questions
var students_high
var players_results
var questions_resutls

func _init():
	_client.connect("connection_established", self, "_client_connected")
	_client.connect("connection_error", self, "_client_disconnected")
	_client.connect("connection_closed", self, "_client_disconnected")
	_client.connect("server_close_request", self, "_client_close_request")
	_client.connect("data_received", self, "_client_received")
	
	#connect_to_url("ws://127.0.0.1:11100")
	connect_to_url(server_url)
	
func _client_connected(protocol):
	Utils._log("Client just connected with protocol: %s" % [protocol])
	_client.get_peer(1).set_write_mode(_write_mode)
	connected = true
	
func _client_disconnected(clean=true):
	Utils._log("Client just disconnected. Was clean: %s" % clean)
	connected = false
	connect_to_url(server_url)
	
func _client_close_request(code,reason):
	Utils._log("Close code: %d, reason: %s" % [code, reason])
	connected = false
	
func _client_received():
	var packet = _client.get_peer(1).get_packet()
	var received = Utils.decode_data(packet)
	Utils._log("Received data: %s" % [Utils.decode_data(packet)])
	
	if received[0] == "CG":
		print("Game successfully created")
		lobby_id = received[1]
		lobby_name = str(lobby_id) + received[2]
		evaluation_page = str(lobby_id) + received[3]
		
		#IF OS not HTML5
		if OS.get_name() != "HTML5":
			var save_lobbies = File.new()
			if save_lobbies.file_exists("user://lobbies.save"):
				save_lobbies.open("user://lobbies.save", File.READ)
				created_lobbies = parse_json(save_lobbies.get_line())
				save_lobbies.close()
			save_lobbies.open("user://lobbies.save", File.WRITE)
			created_lobbies.append([lobby_id, lobby_name, evaluation_page])
			save_lobbies.store_line(to_json(created_lobbies))
			save_lobbies.close()
		
		get_tree().change_scene("res://scenes/LobbyCode.tscn")
	
	if received[0] == "JG":
		print("Joining game")
		questions = []
		words = []
		print(received)
		for q in received[1]:
			questions.append( [q["question"], q["answer"]] )
		for w in received[2]:
			words.append( w["word"] )
		player_name = received[3]
		
		get_tree().change_scene("res://scenes/MemoryGame.tscn")
	
	if received[0] == "GR":
		score = received[1]
		total = received[2]
		correct_questions = received[3]
		wrong_questions = received[4]
		questions_for_gr = received[5]
		game_score = received[6]
		
		get_tree().change_scene("res://scenes/GameResults.tscn")
		
	if received[0] == "EV":
		var analytics = received[1]
		lobby_name = received[2]
		evaluation_page = received[3]
		
		
		player_count = analytics[0][0]["player_count"]
		if player_count == 0:
			error_message = "Empty Evaluation Page!\nNo one has played the game. Try again later."
			throw_error = true
			return
		average_score = analytics[1][0]["average"]
		difficult_questions = analytics[2]
		students_low = analytics[3]
		easy_questions = analytics[4]
		students_high = analytics[5]
		players_results = analytics[6]
		questions_resutls = analytics[7]
		
		get_tree().change_scene("res://scenes/Evaluation.tscn")
		
	if received[0] == "ER":
		error_message = received[1]
		throw_error = true

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
