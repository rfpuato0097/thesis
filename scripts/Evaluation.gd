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
var analytics_text = ""

onready var codes_label = $VBox/Codes
onready var panel1 = $VBox/ScrollContainer/TabContainer/GameSummary/PanelContainer/Content
onready var panel2 = $VBox/ScrollContainer/TabContainer/GameSummary/PanelContainer2/Content

const Item = preload("res://scenes/Item.tscn")

class DictionarySorter:
	static func sort_freq_asc(a,b):
		if a["freq"] < b["freq"]:
			return true
		return false

func _ready():
	codes_label.text = "Evaluation Page Code: %s\nLobby Code: %s" % [result_page_name, lobby_name]
	panel1.text = "No. of Players: %d" % [player_count]
	panel2.text = "Average Score: %.2f%%" % [(average_score * 100)]
	var passers = 0
	for i in student_high.size():
		if int(student_high[i]["correct_ans"]) > (0.60 * question_results.size()):
			passers = passers + 1
			print(passers)
	panel2.text = panel2.text + "\nPassing Rate: %.2f%%" % [ (float(passers)/float(student_high.size()))*float(100) ]



	var item_instance = Item.instance()
	item_instance.title = "Difficult Questions:"
	analytics_text = ""
	#less than 60% of students got it correct
	for i in difficult_questions.size():
		if int(difficult_questions[i]["no_of_correct"]) < (0.60 * players_results.size()):
			analytics_text = analytics_text + "    Question: %s\n        No. of correct answers: %d\n" % [difficult_questions[i]["question"], difficult_questions[i]["no_of_correct"]]
	item_instance.content = analytics_text
	get_node("VBox/ScrollContainer/TabContainer/GameSummary").add_child(item_instance)

	item_instance = Item.instance()
	item_instance.title = "Players that need assistance:"
	analytics_text = ""
	#If less than 60% yung score.
	for i in student_low.size():
		if int(student_low[i]["correct_ans"]) < (0.60 * question_results.size()):
			analytics_text = analytics_text + "    Name: %s\n        Score: %d\n" % [student_low[i]["player_name"], student_low[i]["correct_ans"]]
	item_instance.content = analytics_text
	get_node("VBox/ScrollContainer/TabContainer/GameSummary").add_child(item_instance)
	
	item_instance = Item.instance()
	item_instance.title = "Easy Questions:"
	analytics_text = ""
	#more than 80% of students got it correct
	for i in easy_questions.size():
		if int(easy_questions[i]["no_of_correct"]) > (0.80 * players_results.size()):
			analytics_text = analytics_text + "    Question: %s\n        No. of correct answers: %d\n" % [easy_questions[i]["question"], easy_questions[i]["no_of_correct"]]
	item_instance.content = analytics_text
	get_node("VBox/ScrollContainer/TabContainer/GameSummary").add_child(item_instance)

	item_instance = Item.instance()
	item_instance.title = "Players that passed:"
	analytics_text = ""
	for i in student_high.size():
		if int(student_high[i]["correct_ans"]) > (0.60 * question_results.size()):
			analytics_text = analytics_text + "    Name: %s\n        Score: %d\n" % [student_high[i]["player_name"], student_high[i]["correct_ans"]]
	item_instance.content = analytics_text
	get_node("VBox/ScrollContainer/TabContainer/GameSummary").add_child(item_instance)


	#analytics_summary.text = analytics_text


	for i in players_results:
		item_instance = Item.instance()
		item_instance.title = "Player: %s" % [i[0]["player_name"]]
		analytics_text = ""
		var score = 0
		for j in i:
			if j["correct"] == 1:
				score = score + 1
				analytics_text = analytics_text + "\n    Question: %s\n        Correct Answer: %s\n        Player Answer: %s" % [j["question"], j["answer"], j["player_answer"]]
			else:
				analytics_text = analytics_text + "\n    Question: %s\n        Correct Answer: %s\n        Player Answer: %s" % [j["question"], j["answer"], j["player_answer"]]
		analytics_text = "Game Score: %.1f\n" % [i[0]["player_game_score"]] + analytics_text
		analytics_text = "Score: %d/%d\n" % [score, question_results.size()] + analytics_text
		item_instance.content = analytics_text
		get_node("VBox/ScrollContainer/TabContainer/Players").add_child(item_instance)


	for i in question_results:
		item_instance = Item.instance()
		item_instance.title = "Question: %s" % [i[0]["question"]]
		analytics_text = ""
		var score = 0
		var freq = {}
		for j in i:
			if freq.has(j["player_answer"]):
				freq[j["player_answer"]] = freq[j["player_answer"]] + 1
			else:
				freq[j["player_answer"]] = 1

			if j["correct"] == 1:
				score = score + 1
				analytics_text = analytics_text + "\nPlayer: %s\n        Answer: %s\n        Correct? YES" % [j["player_name"], j["player_answer"]]
			else:
				analytics_text = analytics_text + "\nPlayer: %s\n        Answer: %s\n        Correct? NO" % [j["player_name"], j["player_answer"]]
		
		var freqArray = []
		for x in freq:
			freqArray.append( {"answer": x, "freq": freq[x]} )
		freqArray.sort_custom(DictionarySorter, "sort_freq_asc")
		print(freqArray)
		
		for l in freqArray:
			analytics_text = "    %s : %d\n" % [l["answer"], l["freq"]] + analytics_text
		analytics_text = "Answers Frequency: \n" + analytics_text
		analytics_text = "Correct Answer: %s\nScore: %d/%d\n" % [i[0]["answer"], score, players_results.size()] + analytics_text
		item_instance.content = analytics_text
		get_node("VBox/ScrollContainer/TabContainer/Questions").add_child(item_instance)


func _on_Return_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
