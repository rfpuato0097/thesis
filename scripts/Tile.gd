extends MarginContainer

var text = "TILE"
var labelNode

# Called when the node enters the scene tree for the first time.
func _ready():
	labelNode = self.get_child(1)
	labelNode.set_text("HELLO")
	

func showTile():
	labelNode.set_text(text)
	
func hideTile():
	labelNode.set_text("")
