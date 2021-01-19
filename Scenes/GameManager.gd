extends Node2D

export (String, FILE, "*.tscn") var knightFile: String

export (String, FILE, "*.tscn") var huntressFile: String

export (String, FILE, "*.tscn") var peasantFile: String

export (String, FILE, "*.tscn") var ninjaFile: String

export (String, FILE, "*.png") var ninjaIcon: String

export (String, FILE, "*.png") var knighIcon: String

export (String, FILE, "*.png") var huntressIcon: String

export (String, FILE, "*.png") var peasantIcon: String

export (int) var player1CurrentSelection: int = 0

export (int) var player2CurrentSelection: int = 0

onready var gameCamera: Camera2D = get_node("Camera2D")

onready var menuCamera: Camera2D = get_node("MenuCamera")

onready var player1SpawnPos: Position2D = get_node("Player1SpawnPosition")

onready var player2SpawnPos: Position2D = get_node("Player2SpawnPosition")

onready var player1Display: Sprite = get_node("MenuCamera/Control/player1_icon")

onready var player2Display: Sprite = get_node("MenuCamera/Control/player2_icon")

onready var selectionSound:AudioStreamPlayer2D = get_node("SelectionSound");

var currentlyInTheGame: bool = false

var selectIsPressed: bool = false

var anyPlayer1SwitchKeyIsDown: bool = false

var anyPlayer2SwitchKeyIsDown: bool = false


func _ready():
	menuCamera.current = true
	gameCamera.current = false
	pass


func _is_key_down(inputName: String, inputDeviceId: int) -> bool:
	return (
		Input.is_action_pressed("keyboard" + String(inputDeviceId) + "_" + inputName)
		|| Input.is_action_pressed("gamepad" + String(inputDeviceId) + "_" + inputName)
	)


func _process(delta):
	if Input.is_action_pressed("select") && ! selectIsPressed:
		print("select")
		selectIsPressed = true
		if ! currentlyInTheGame:
			print(player1CurrentSelection)
			currentlyInTheGame = true
			menuCamera.current = false
			gameCamera.current = true

			var fileToLoad: String = ""

			match player1CurrentSelection:
				0:
					fileToLoad = knightFile
				1:
					fileToLoad = huntressFile
				2:
					fileToLoad = peasantFile
				3:
					fileToLoad = ninjaFile

			var scene = load(fileToLoad)
			var player1 = scene.instance()
			player1.name = "Player0"
			player1.position = player1SpawnPos.position
			add_child(player1)

			match player2CurrentSelection:
				0:
					fileToLoad = knightFile
				1:
					fileToLoad = huntressFile
				2:
					fileToLoad = peasantFile
				3:
					fileToLoad = ninjaFile

			scene = load(fileToLoad)
			var player2 = scene.instance()
			player2.name = "Player1"
			player2.inputDeviceId = 1
			player2.position = player2SpawnPos.position
			add_child(player2)

			(get_node("Player1Health") as PlayerStatsDisplay)._attach_to_player()
			(get_node("Player2Health") as PlayerStatsDisplay)._attach_to_player()

		else:
			currentlyInTheGame = false
			menuCamera.current = true
			gameCamera.current = false
			if get_node("Player0") != null && get_node("Player1") != null:
				get_node("Player0").queue_free()
				get_node("Player1").queue_free()
	elif ! Input.is_action_pressed("select"):
		selectIsPressed = false

	if ! currentlyInTheGame:
		if _is_key_down("left", 0) && ! anyPlayer1SwitchKeyIsDown:
			player1CurrentSelection += 1
			if player1CurrentSelection > 3:
				player1CurrentSelection = 0

			anyPlayer1SwitchKeyIsDown = true
			selectionSound.play();

		elif _is_key_down("right", 0) && ! anyPlayer1SwitchKeyIsDown:
			player1CurrentSelection -= 1
			if player1CurrentSelection < 0:
				player1CurrentSelection = 3

			anyPlayer1SwitchKeyIsDown = true
			selectionSound.play();

		elif !_is_key_down("right", 0) && !_is_key_down("left", 0):
			anyPlayer1SwitchKeyIsDown = false

		match player1CurrentSelection:
			0:
				player1Display.set_texture(load(knighIcon))
			1:
				player1Display.set_texture(load(huntressIcon))
			2:
				player1Display.set_texture(load(peasantIcon))
			3:
				player1Display.set_texture(load(ninjaIcon))

		if _is_key_down("left", 1) && ! anyPlayer2SwitchKeyIsDown:
			player2CurrentSelection += 1
			if player2CurrentSelection > 3:
				player2CurrentSelection = 0
			anyPlayer2SwitchKeyIsDown = true
			selectionSound.play();
		elif _is_key_down("right", 1) && ! anyPlayer2SwitchKeyIsDown:
			player2CurrentSelection -= 1
			if player2CurrentSelection < 0:
				player2CurrentSelection = 3
			anyPlayer2SwitchKeyIsDown = true
			selectionSound.play();
		elif !_is_key_down("right", 1) && !_is_key_down("left", 1):
			anyPlayer2SwitchKeyIsDown = false

		match player2CurrentSelection:
			0:
				player2Display.set_texture(load(knighIcon))
			1:
				player2Display.set_texture(load(huntressIcon))
			2:
				player2Display.set_texture(load(peasantIcon))
			3:
				player2Display.set_texture(load(ninjaIcon))

	pass
