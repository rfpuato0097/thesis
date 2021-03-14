extends Control

var lobby_name = Client.lobby_name
var result_page_name = Client.evaluation_page

onready var codes_label = $VBoxContainer/Codes

func _ready():
	codes_label.text = "Evaluation Page Code: %s\nLobby Code: %s" % [result_page_name, lobby_name]


func _on_Return_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
