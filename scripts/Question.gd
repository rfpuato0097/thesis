extends HBoxContainer

onready var questionLabel = $QuestionContainer/QuestionNoLabel
var questionNo = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	questionLabel.set_text("Question#%d" % [questionNo])
	add_to_group("QuestionsGroup")
	
	
func collectQuestion():
	var question = $QuestionContainer/QuestionInput.get_text()
	var answers = $AnswerContainer/AnswerInput.get_text()
	return {question:answers}

func test():
	print("TESTING")
