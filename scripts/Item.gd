extends VBoxContainer

var show = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Title_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			show = !show
			get_node("Content").visible = show
