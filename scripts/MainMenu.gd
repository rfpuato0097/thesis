extends Control

var created_lobbies = []
var music_player

onready var joinPopup = $JoinGamePopup
onready var CheckPopup = $CheckGamePopup
onready var errorPopup = $ErrorPopup
onready var infoPopup = $InfoPopup
onready var exitButton = $Container/MenuContainer/Exit
onready var lobbyList = $CheckGamePopup/VBoxContainer/ScrollContainer
onready var connectedLabel = $Container/MenuContainer/Infos/connected

func _ready():
	if OS.get_name() != "HTML5":
		var save_lobbies = File.new()
		if save_lobbies.file_exists("user://lobbies.save"):
			save_lobbies.open("user://lobbies.save", File.READ)
			created_lobbies = parse_json(save_lobbies.get_line())
			save_lobbies.close()
			
			for lobby in created_lobbies:
				lobbyList.get_node("PanelContainer/Label").text = lobbyList.get_node("PanelContainer/Label").text + "%s:%s\n" % [lobby[1], lobby[2]]
	
	if OS.get_name() == "HTML5":
		exitButton.hide()
		lobbyList.hide()
		#CheckPopup.rect_size = Vector2(200,100)
		CheckPopup.margin_top = -50
		CheckPopup.margin_bottom = 50
		CheckPopup.rect_size = Vector2(144,115)
		
func _process(delta):
	if Client.throw_error == true:
		errorPopup.get_node("ErrorMessage").text = Client.error_message
		errorPopup.popup()
		Client.throw_error = false
	
	if Client.connected == true:
		connectedLabel.text = "Connected to Server!"
	else:
		connectedLabel.text = "Not Connected to Server..."

func _on_CreateGameButton_pressed():
	print("Create Game Pressed")
	get_tree().change_scene("res://scenes/CreateGame.tscn")

func _on_JoinGameButton_pressed():
	print("Join Game Pressed")
	joinPopup.popup()

func _on_CheckGameButton_pressed():
	print("Check Game Pressed")
	CheckPopup.popup()


func _on_Exit_pressed():
	get_tree().quit()


func _on_InfoButton_pressed():
	infoPopup.popup()
