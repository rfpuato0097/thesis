extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Label_gui_input(event):
	print(event)
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("PRESSSING")
			self.visible = !visible
