extends Control

var lobby_name = Client.lobby_name
var result_page_name = Client.evaluation_page
var player_count = Client.player_count
var average_score = Client.average_score
var difficult_questions = Client.difficult_questions
var student_low = Client.students_low
var easy_questions = Client.easy_questions
var student_high = Client.students_high
var players_results = Client.players_results
var question_results = Client.questions_resutls

onready var codes_label = $VBox/Codes
onready var analytics_label = $VBox/ScrollContainer/VBox/Analytics

func _ready():
	codes_label.text = "Evaluation Page Code: %s\nLobby Code: %s" % [result_page_name, lobby_name]
	var analytics_text = "Game Summary\nNo. of Players: %d\n" % [player_count]
	analytics_text = analytics_text + "Average Score: %.2f\n" % [average_score]
	
	analytics_text = analytics_text + "Difficult Questions:\n"
	#less than 60% of students got it correct
	for i in difficult_questions.size():
		if int(difficult_questions[i]["no_of_correct"]) < (0.60 * players_results.size()):
			analytics_text = analytics_text + "    Question: %s\n        No. of correct answers: %d\n" % [difficult_questions[i]["question"], difficult_questions[i]["no_of_correct"]]
	
	analytics_text = analytics_text + "Players that need assistance:\n"
	#If less than 60% yung score.
	for i in student_low.size():
		if int(student_low[i]["correct_ans"]) < (0.60 * question_results.size()):
			analytics_text = analytics_text + "    Name: %s\n        Score: %d\n" % [student_low[i]["player_name"], student_low[i]["correct_ans"]]
			
	analytics_text = analytics_text + "Easiest Questions:\n"
	#more than 60% of students got it correct
	for i in easy_questions.size():
		if int(easy_questions[i]["no_of_correct"]) > (0.60 * players_results.size()):
			analytics_text = analytics_text + "    Question: %s\n        No. of correct answers: %d\n" % [easy_questions[i]["question"], easy_questions[i]["no_of_correct"]]

	analytics_text = analytics_text + "Top Players:\n"
	for i in student_high.size():
		if int(student_high[i]["correct_ans"]) > (0.60 * question_results.size()):
			analytics_text = analytics_text + "    Name: %s\n        Score: %d\n" % [student_high[i]["player_name"], student_high[i]["correct_ans"]]

	analytics_text = analytics_text + "Players:\n"
	for i in players_results:
		analytics_text = analytics_text + "    Player: %s\n" % [i[0]["player_name"]]
		for j in i:
			analytics_text = analytics_text + "        Question: %s\n            Correct: %d\n" % [j["question"], j["correct"]]

	analytics_text = analytics_text + "Questions:\n"
	print(question_results)
	for i in question_results:
		analytics_text = analytics_text + "    Question: %s\n" % [i[0]["question"]]
		for j in i:
			analytics_text = analytics_text + "        Player: %s\n            Correct: %d\n" % [j["player_name"], j["correct"]]

	analytics_label.text = analytics_text

func _on_Return_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
