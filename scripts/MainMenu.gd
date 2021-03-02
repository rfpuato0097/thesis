extends Control

onready var joinPopup = $JoinGamePopup

func _on_CreateGameButton_pressed():
	print("Create Game Pressed")
	Client.send_data("CG")
	get_tree().change_scene("res://scenes/CreateGame.tscn")

func _on_JoinGameButton_pressed():
	print("Join Game Pressed")
	joinPopup.popup()
