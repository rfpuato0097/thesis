extends Panel

var toggle = true
var size_norm
var size_small
onready var parent = get_tree().get_root().get_node("Evaluation/VBox/ScrollContainer/VBox")

func _ready():
	size_norm = self.rect_size.y
	size_small = float(10)

func _on_Panel_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print(self.rect_size.x)
			print(self.rect_size.y)
			
			toggle = !toggle
			for child in self.get_children():
				if toggle == true:
					child.show()
					self.rect_size.y = size_norm
					parent.update()
				else:
					self.rect_size.y = size_small
					child.hide()
					parent.update()
					
