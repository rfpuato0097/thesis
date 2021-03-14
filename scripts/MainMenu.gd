extends Control

onready var joinPopup = $JoinGamePopup
onready var CheckPopup = $CheckGamePopup

func _on_CreateGameButton_pressed():
	print("Create Game Pressed")
	get_tree().change_scene("res://scenes/CreateGame.tscn")

func _on_JoinGameButton_pressed():
	print("Join Game Pressed")
	joinPopup.popup()

func _on_CheckGameButton_pressed():
	print("Check Game Pressed")
	CheckPopup.popup()
