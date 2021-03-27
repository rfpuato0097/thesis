extends VBoxContainer

var show = false
var title = "Title"
var content = "Content"

onready var titleLabel =  $Title/Label
onready var contentLabel = $Content/Label

func _ready():
	titleLabel.set_text("> "+title)
	contentLabel.set_text(content)
	get_node("Content").visible = show



func _on_Title_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			show = !show
			if !show:
				titleLabel.set_text("> "+title)
			else:
				titleLabel.set_text(title)
			get_node("Content").visible = show
