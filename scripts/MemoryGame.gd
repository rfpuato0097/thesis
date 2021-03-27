extends Control

onready var questionsArea = $VerticalContainer/QuestionsArea/QuestionsContainer/Questions
onready var tileGrid = $VerticalContainer/AnswersArea/TileGrid
onready var lobbyInfo = $VerticalContainer/QuestionsArea/LobbyInfoContainer/LobbyInfo

var questions = []
var questionTotal
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
var playerAnswer
var playerScore = 0
var playerName
var correctQuestions = []
var wrongQuestions = []

func _ready():
	tiles = tileGrid.get_children()
	#Receive Data from Server
	questions = Client.questions
	words = Client.words
	playerName = Client.player_name
	#Temporary Values for testing. Server will be set up later.
	#questions = [ ["q1","a1"], ["q2","a2"], ["q3","a3"], ["q4","a4"] ]
	#words = [ "a5", "a6" ]
	#playerName = "Monra"
	
	questionTotal = questions.size()
	
	#Get Words for tiles.
	for q in questions:
		words.append( q[1] )
	
	#5 sec. Countdown at Questions Area
	gameTimer(5, "_question_start")

	
func _process(delta):
	#Displays the timer in the questions area.
	if(timer.get_time_left() > 0 and displayTimer):
		questionsArea.set_text( str(round(timer.get_time_left())) )
	
	#Makes it so there is only one tile clicked.
	if clickedTile:
		for tile in tiles:
			if clickedTile != tile:
				tile.buttonNode.set_pressed(false)

	#Display to lobby info.
	lobbyInfo.set_text( "Player Name: %s\nPlayer Score: %d/%d" % [playerName, playerScore, questionTotal] )


func gameTimer(secs, method, oneShot=true):
	timer = Timer.new()
	timer.set_autostart(false)
	timer.set_one_shot(oneShot)
	timer.set_wait_time(secs)
	timer.connect("timeout" , self, method)
	add_child(timer)
	timer.start()

func _question_start():
	if questions:
		pickQuestion()
		prepareTiles()
		memorizePhase()
	else:
		#Game End
		#Send result to server here.
		Client.send_data(["GR", playerName, correctQuestions, wrongQuestions])
		pass

func pickQuestion():
	print("pickQuestion")
	question = questions.pop_front()
	#usedQuestions.append(question)
	answer = question[1]
	question = question[0]


func prepareTiles():
	print("prepareTiles")
	tempWords = words.duplicate(true)
	wordsInTiles.append(answer)
	tempWords.erase(answer)
	rng.randomize()
	tempWords.shuffle()

	for i in range(5):
		wordsInTiles.append( tempWords.pop_front() )

	var ansCount = 0
	var repeatTiles = true
	while(repeatTiles):
		for tile in tiles: #
			tile.text = wordsInTiles[ rng.randi_range(0, 5) ]
			if tile.text == answer:
				ansCount = ansCount + 1
		if ansCount >= 3:
			repeatTiles = false
		ansCount = 0
		#print(tiles)
	#print("\nTILES\n")
	
	
	for tile in tiles:
		tile.buttonNode.set_disabled(true)
		tile.buttonNode.set_pressed(false)

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
		if tile.text == answer:
			tile.showTile()
		else:
			tile.hideTile()
		tile.buttonNode.set_disabled(true)
	if clickedTile:
		playerAnswer = clickedTile.text
	if playerAnswer == answer:
		print("Correct")
		playerScore = playerScore + 1
		correctQuestions.append( {"question":question, "player_answer": playerAnswer} )
		#correctQuestions.append(question)
	else:
		print("Wrong")
		wrongQuestions.append( {"question":question, "player_answer": playerAnswer} )
	gameTimer(2, "_question_start")
