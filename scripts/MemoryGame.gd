extends Control

onready var questionsArea = $VerticalContainer/QuestionsArea/QuestionsContainer/Questions
onready var tileGrid = $VerticalContainer/AnswersArea/TileGrid

var questions = []
var usedQuestions = []
var words = []
var question
var answer
var wordsInTiles = []
var tempWords
var flip = true
var flipCounter = 0
var timer
var displayTimer = true
var rng = RandomNumberGenerator.new()
var tiles
var clickedTile
var disabledTiles = false
var playerAnswer

func _ready():
	tiles = tileGrid.get_children()
	
	#Receive Questions from Server
	#Temporary Values for testing. Server will be set up later.
	questions = [ ["q1","a1"], ["q2","a2"], ["q3","a3"], ["q4","a4"] ]
	words = [ "a5", "a6" ]
	
	#Get Words for tiles.
	for q in questions:
		words.append( q[1] )
	
	#5 sec. Countdown at Questions Area
	gameTimer(5, "_game_start")

	
func _process(delta):
	if(timer.get_time_left() > 0 and displayTimer):
		questionsArea.set_text( str(round(timer.get_time_left())) )
	
	if clickedTile and !disabledTiles:
		for tile in tiles:
			if clickedTile != tile:
				tile.buttonNode.set_pressed(false)


func gameTimer(secs, method, oneShot=true):
	timer = Timer.new()
	timer.set_autostart(false)
	timer.set_one_shot(oneShot)
	timer.set_wait_time(secs)
	timer.connect("timeout" , self, method)
	add_child(timer)
	timer.start()

func _game_start():
	if questions:
		pickQuestion()
		prepareTiles()
		memorizePhase()
	else:
		#Game End
		pass

func pickQuestion():
	print("pickQuestion")
	question = questions.pop_front()
	usedQuestions.append(question)
	answer = question[1]
	question = question[0]


func prepareTiles():
	print("prepareTiles")
	tempWords = words.duplicate(true)
	wordsInTiles.append(answer)
	tempWords.erase(answer)
	randomize()
	tempWords.shuffle()

	for i in range(5):
		wordsInTiles.append( tempWords.pop_front() )

	for tile in tiles:
		tile.text = wordsInTiles[ rng.randi_range(0, 5) ]
	
	for tile in tiles:
		tile.buttonNode.set_disabled(disabledTiles)

func flipTiles():
	rng.randomize()
	if flipCounter == 5:
		flipCounter = 0
		timer.stop()
		for tile in tiles:
			tile.hideTile()
		gameTimer(0.1, "answerPhase")
		return
	else:
		flipCounter = flipCounter + 1
		print("Flips: " + str(flipCounter))
	
	for tile in tiles:
		if rng.randi_range(0, 1) == 1:
			tile.showTile()
		else:
			tile.hideTile()

func memorizePhase():
	print("memorizePhase")
	displayTimer = false
	questionsArea.set_text("Remember the Tiles")
	flipTiles()
	gameTimer(3, "flipTiles", false)

func answerPhase():
	print("answerPhase")
	for tile in tiles:
		tile.buttonNode.set_disabled(false)
	questionsArea.set_text(question)
	gameTimer(5, "resultPhase")
	
func resultPhase():
	print("resultPhase")
	for tile in tiles:
		tile.showTile()
		tile.buttonNode.set_disabled(true)
	if clickedTile:
		playerAnswer = clickedTile.text
	if playerAnswer == answer:
		print("Correct")
	else:
		print("Wrong")
	gameTimer(2, "_game_start")
