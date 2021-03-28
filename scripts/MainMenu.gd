extends Control

var created_lobbies = []

onready var joinPopup = $JoinGamePopup
onready var CheckPopup = $CheckGamePopup
onready var errorPopup = $ErrorPopup
onready var exitButton = $Container/TitleContainer/Exit
onready var lobbyList = $CheckGamePopup/VBoxContainer/ScrollContainer

func _ready():
	var save_lobbies = File.new()
	if save_lobbies.file_exists("res://lobbies.save"):
		save_lobbies.open("res://lobbies.save", File.READ)
		created_lobbies = parse_json(save_lobbies.get_line())
		save_lobbies.close()
		
		for lobby in created_lobbies:
			lobbyList.get_node("PanelContainer/Label").text = lobbyList.get_node("PanelContainer/Label").text + "%s:%s\n" % [lobby[1], lobby[2]]
	
	if OS.get_name() == "HTML5":
		exitButton.hide()
		lobbyList.hide()
		CheckPopup.rect_size = Vector2(144,80)
		CheckPopup.margin_top = -50
		CheckPopup.margin_bottom = 50
		
func _process(delta):
	if Client.throw_error == true:
		errorPopup.get_node("ErrorMessage").text = Client.error_message
		errorPopup.popup()
		Client.throw_error = false

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
