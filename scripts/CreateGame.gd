extends Control

var questionInstance = preload("res://scenes/Question.tscn")
var counter = 2
var questions = []
var isSendData = true
onready var wordsPopup = $AddtlWordsPopup

func _ready():
	pass # Replace with function body.
	

func _on_AddQuestionButton_pressed():
	var q = questionInstance.instance()
	q.questionNo = counter
	counter += 1
	get_node("VBoxContainer/ScrollContainer/VBoxContainer").add_child(q)
	print("Adding Question")


func _on_RemoveQuestion_pressed():
	var lastChild = $VBoxContainer/ScrollContainer/VBoxContainer.get_child_count()
	if lastChild > 1:
		lastChild = $VBoxContainer/ScrollContainer/VBoxContainer.get_child(lastChild-1)
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
		wordsPopup.popup()

	#Data is sent to Server.
	if isSendData:
		Client.send_data(questions)
	
	var json = JSON.print(questions, "\t")
	print (json)


func _on_ExportButton_pressed():
	pass # Replace with function body.


func _on_ImportButton_pressed():
	pass # Replace with function body.


func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_Ok_pressed():
	wordsPopup.sendAddtlWords()
	isSendData = true
	Client.send_data(questions)
	Client.send_data(wordsPopup.words)
	
	print( wordsPopup.words )
