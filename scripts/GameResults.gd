extends Control

var score = Client.score
var total = Client.total
var correct_questions = Client.correct_questions.duplicate(true)
var wrong_questions = Client.wrong_questions.duplicate(true)
var questions = Client.questions_for_gr.duplicate(true)

var correctText = "Questions you got right:\n"
var wrongText = "Questions you got wrong:\n"

onready var gameResults = $VBoxContainer/GameResults
onready var correctQuestions = $VBoxContainer/HBoxContainer/CorrectQuestionsContainer/CorrectQuestions
onready var wrongQuestions = $VBoxContainer/HBoxContainer/WrongQuestionsContainer/WrongQuestions

func _ready():
	gameResults.text = "Score: %d/%d" % [score,total]
	
	for c in correct_questions:
		for q in questions:
			if c["question"] == q["question"]:
				correctText = correctText + ("%s:%s\n" % [ q["question"], q["answer"] ])

	for w in wrong_questions:
		for q in questions:
			if w["question"] == q["question"]:
				wrongText = wrongText + ("%s:%s\n    Your Answer: %s\n" % [ q["question"], q["answer"], w["player_answer"] ])

	correctQuestions.set_text(correctText)
	wrongQuestions.set_text(wrongText)

func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
