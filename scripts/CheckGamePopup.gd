extends WindowDialog

onready var evalCodeLabel = $VBoxContainer/EvalCodeLabel
onready var evalCode = $VBoxContainer/EvalCode

func _on_EvalEnter_pressed():
	Client.send_data(["EV", evalCode.get_text()])
