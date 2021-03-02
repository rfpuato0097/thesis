extends WindowDialog

onready var lobbyCode = $VBoxContainer/LobbyCode
onready var playerName = $VBoxContainer/Name 

func _on_EnterButton_pressed():
	print ("JG %s %s" % [lobbyCode.get_text(), playerName.get_text()])
	Client.send_data("JG %s %s" % [lobbyCode.get_text(), playerName.get_text()])
