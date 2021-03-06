extends MarginContainer

var text = "TILE"
var buttonNode
var labelNode

onready var MemoryGame

# Called when the node enters the scene tree for the first time.
func _ready():
	buttonNode = self.get_child(0)
	labelNode = self.get_child(1)
	
	buttonNode.connect("pressed", self, "_button_pressed")
	buttonNode.set_toggle_mode(true)
	labelNode.set_text("HELLO")
	
	MemoryGame = get_node("../../../..")

func showTile():
	labelNode.set_text(text)


func hideTile():
	labelNode.set_text("")

func _button_pressed():
	MemoryGame.clickedTile = self
