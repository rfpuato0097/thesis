extends HBoxContainer

onready var questionLabelNode = $QuestionContainer/QuestionNoLabel
onready var questionInputNode = $QuestionContainer/QuestionInput
onready var answerInputNode = $AnswerContainer/AnswerInput
var questionNo = 1
var questionInput = ""
var answerInput = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	questionLabelNode.set_text("Question#%d" % [questionNo])
	questionInputNode.set_text(questionInput)
	answerInputNode.set_text(answerInput)
	
	add_to_group("QuestionsGroup")
	
	
func collectQuestion():
	var question = $QuestionContainer/QuestionInput.get_text()
	var answer = $AnswerContainer/AnswerInput.get_text()
	return [question, answer]
