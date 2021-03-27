extends Control

var lobby_code = Client.lobby_name
var evaluation_page_code = Client.evaluation_page

onready var codeLabel = $VBoxContainer/PanelContainer/VBoxContainer/PanelContainer/Code
onready var infoLabel = $VBoxContainer/PanelContainer/VBoxContainer/Info

func _ready():
	codeLabel.text = "Lobby Code: %s\nEvaluation Page Code: %s" % [lobby_code, evaluation_page_code]
	infoLabel.text = """Send the Lobby Code to your players so they can play the game.
	They'll have to input the Lobby Code into the Join Game popup in the Main Menu to start a game.
	
	Use the Evaluation Page Code to view the results of the game and the learning analytics made by the server.
	"""


func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
	
