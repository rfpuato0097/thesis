extends Control

var questionInstance = preload("res://scenes/Question.tscn")
var counter = 2
var questions = []
var isSendData = true
var payload = []
onready var wordsPopup = $AddtlWordsPopup
onready var savePopup = $SavePopup
onready var loadPopup = $LoadPopup

func _ready():
	pass # Replace with function body.
	

func _on_AddQuestionButton_pressed():
	var q = questionInstance.instance()
	q.questionNo = counter
	counter += 1
	get_node("VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer").add_child(q)
	print("Adding Question")


func _on_RemoveQuestion_pressed():
	var lastChild = $VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer.get_child_count()
	if lastChild > 1:
		lastChild = $VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer.get_child(lastChild-1)
		print(lastChild)
		lastChild.queue_free()
		counter -= 1


func _on_CreateGameButton_pressed():
	#Collects the question and answers then places them on a list.
	questions = []
	for member in get_tree().get_nodes_in_group("QuestionsGroup"):
		questions.append( member.collectQuestion() )
		
	#Game needs 6 words.
	#If less than 6 then ask host for more.
	if(questions.size() < 6):
		isSendData = false
		print("Not Enougn Words for Game")
		wordsPopup.addWords(5 - questions.size())
		wordsPopup.show()

	#Data is sent to Server.
	if isSendData:
		payload.append("CG")
		payload.append(questions)
		Client.send_data(payload)
		print("Data Sent")
	
	#var json = JSON.print(questions, "\t")
	#print (json)


func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_Ok_pressed():
	wordsPopup.sendAddtlWords()
	isSendData = true
	
	payload.append("CG")
	payload.append(questions)
	payload.append(wordsPopup.words)
	
	Client.send_data(payload)
	print(payload)


func _on_AddtlWordsPopup_hide():
	isSendData = true


func _on_SaveButton_pressed():
	savePopup.show()

func _on_LoadButton_pressed():
	loadPopup.show()

func _on_LoadPopup_file_selected(path):
	var load_file = File.new()
	load_file.open(path,File.READ)
	
	var savedQuestions = parse_json(load_file.get_line())
	
	#Removes the previous questions
	var node = get_node("VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer")
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()
	
	#Add questions
	counter = 1
	for question in savedQuestions:
		var q = questionInstance.instance()
		q.questionNo = counter
		q.questionInput = question[0]
		q.answerInput = question[1]
		counter += 1
		get_node("VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer").add_child(q)
		
	loadPopup.hide()


func _on_SavePopup_file_selected(path):
	var save_file = File.new()
	var saveName = path.get_basename() + ".save"
	save_file.open(saveName, File.WRITE)
	
	var savedQuestions = []
	for member in get_tree().get_nodes_in_group("QuestionsGroup"):
		savedQuestions.append( member.collectQuestion() )

	save_file.store_line(to_json(savedQuestions))
	save_file.close()
	savePopup.hide()
