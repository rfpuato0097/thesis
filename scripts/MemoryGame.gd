extends Control

onready var questionsArea = $VerticalContainer/QuestionsArea/QuestionsContainer/Questions
onready var tileGrid = $VerticalContainer/AnswersArea/TileGrid

var questions = []
var usedQuestions = []
var words = []
var flip = true
var flipCounter = 0
var timer
var displayTimer = true
var rng = RandomNumberGenerator.new()
var tiles
var clickedTile

func _ready():
	tiles = tileGrid.get_children()
	
	#Receive Questions from Server
	#Temporary Values for testing. Server will be set up later.
	questions = [ ["q1","a1"], ["q2","a2"], ["q3","a3"], ["q4","a4"] ]
	words = [ "a5", "a6" ]
	
	#Get Words for tiles.
	for question in questions:
		words.append( question[1] )
	
	#5 sec. Countdown at Questions Area
	gameTimer(5, "_game_start",false)
	
	#Start 15sec timer. Flip tiles.
	#Show Question Start 15sec timer
	
	pass
	
	
func _process(delta):
	if(timer.get_time_left() > 0 and displayTimer):
		questionsArea.set_text( str(round(timer.get_time_left())) )
		pass


func gameTimer(secs, method, oneShot=true):
	timer = Timer.new()
	timer.set_autostart(false)
	timer.set_one_shot(oneShot)
	timer.set_wait_time(secs)
	timer.connect("timeout" , self, method)
	add_child(timer)
	timer.start()

func _game_start():
	timer.stop()
	
	#Pick Question
	var question
	var answer
	if questions:
		print("Game Starting")
		question = questions.pop_front()
		usedQuestions.append(question)
		answer = question[1]
		question = question[0]
	else:
		#end game
		return
	
	print("QUESTION: " + question)
	print("ANSWER: " + answer)
	
	#Place words at tiles.
	var wordsInTiles = []
	var tempWords = words.duplicate(true)
	wordsInTiles.append(answer)
	tempWords.erase(answer)
	randomize()
	tempWords.shuffle()

	for i in range(5):
		wordsInTiles.append( tempWords.pop_front() )

	for tile in tiles:
		tile.text = wordsInTiles[ rng.randi_range(0, 5) ]
		
	gameTimer(3, "flipTiles", false)
	
func flipTiles():
	rng.randomize()
	if flipCounter == 5:
		flipCounter = 0
		timer.stop()
		return
	else:
		flipCounter = flipCounter + 1
		print("Flips: " + str(flipCounter))
	
	for tile in tiles:
		if rng.randi_range(0, 1) == 1:
			tile.showTile()
		else:
			tile.hideTile()
