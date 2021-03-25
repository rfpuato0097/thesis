extends WindowDialog

onready var lobbyCode = $VBoxContainer/LobbyCode
onready var playerName = $VBoxContainer/Name 

func _on_EnterButton_pressed():
	Client.send_data(["JG", lobbyCode.get_text().to_upper(), playerName.get_text()])
