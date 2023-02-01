extends Control

onready var tween = $BarTween
onready var healthBar = $Health/Bar
onready var staminaBar = $Stamina/Bar

onready var coinCount = $Coin/Count

onready var menuMove = $MenuMove
onready var endPlayer = $EndPlayer
onready var dink = $Dink

onready var roomContainer = $Map/Rooms
var square = load("res://UserInterface/square.png")

var ended = false

var timeAddChar = 0.1


var taunts = {
	1 : "Skill issue",
	2 : "Maybe try killing the enemies? Just sayin'..",
	3 : "Duck! oh wait... you cant",
	4 : "Maybe it's time to take a deep breath",
	5 : "You weren't even close...",
	6 : "Oh well.. there is always next time",
	7 : "Close, but no cigar",
	8 : "You do know the goal is not to die right?",
	9 : "Gonna cry?",
	10 : "Hello? Are you even paying attention",
	11 : "Insanity: Noun : The process of doing the same thing over and over and expecting change. Ring a bell?",
}

var doneSelected = 0

func _ready():
	while GameData.roomPositions == []:
		pass
	
	for room in GameData.roomPositions:
		#make rooms
		var roomVector = room / 640
		var sqr = TextureRect.new()
		sqr.texture = square
		sqr.rect_position = Vector2(64, 64) + (roomVector * 16)
		roomContainer.add_child(sqr)
		
		#toggle visibility of rooms too far on map
		if sqr.rect_position.x < 0 or sqr.rect_position.x > 128 or sqr.rect_position.y < 0 or sqr.rect_position.y > 128:
			sqr.visible = false
		else:
			sqr.visible = true

onready var arrow = $Border/Arrow
onready var arrow2 = $WinBorder/Arrow
onready var gameOver = $GameOver
onready var taunt = $Border/taunt
onready var scores = $WinBorder/scores
onready var scoreTypes = $WinBorder/ScoreTypes

func _process(delta):
	if GameData.playerHealth > 0 and ended == false:
		#show health and change color of bar
		tween.interpolate_property(healthBar, "rect_size", null, Vector2(GameData.playerHealth * 10, 4), 0.2, 1)
		tween.interpolate_property(healthBar, "color", null, Color(1 - (GameData.playerHealth / 10), GameData.playerHealth / 5, 0, 1), 0.2, 1)
		tween.interpolate_property(staminaBar, "rect_size", null, Vector2(GameData.playerStamina * 10, 4), 0.2, 1)
		tween.start()
		if GameData.playerHealth <= 3:
			$LowHealth.play("pulse")
		
		if GameData.finished == true:
			scores.visible_characters = 0
			scoreTypes.visible_characters = 0
			get_parent().get_parent().get_child(0).queue_free()
			gameOver.play("win")
			get_tree().paused = true
			endPlayer.play()
			ended = true
		
		if GameData.playerCoins < 10:
			coinCount.text = "0" + str(GameData.playerCoins)
		else:
			coinCount.text = str(GameData.playerCoins)
	elif GameData.playerHealth <= 0:
		if Input.is_action_just_pressed("ui_up"):
			menuMove.play()
			doneSelected -= 1
			if doneSelected < 0:
				doneSelected = 1
		if Input.is_action_just_pressed("ui_down"):
			menuMove.play()
			doneSelected += 1
			if doneSelected > 1:
				doneSelected = 0
		
		if taunt.visible_characters < len(taunt.text) - 5:
			if timeAddChar <= 0:
				timeAddChar = 0.075
				dink.play()
				taunt.visible_characters += 1
			else:
				timeAddChar -= delta
		
		arrow.rect_position.y = 328 + (64 * doneSelected)
		
		if Input.is_action_just_pressed("interact"):
			if doneSelected == 0:
				get_tree().paused = false
				GameData.reset()
				get_tree().reload_current_scene()
			elif doneSelected == 1:
				returnToMenu()
	elif ended == true:
		
		if Input.is_action_just_pressed("ui_up"):
			menuMove.play()
			doneSelected -= 1
			if doneSelected < 0:
				doneSelected = 1
		if Input.is_action_just_pressed("ui_down"):
			menuMove.play()
			doneSelected += 1
			if doneSelected > 1:
				doneSelected = 0
		
		arrow2.rect_position.y = 456 + (64 * doneSelected)
		
		if Input.is_action_just_pressed("interact"):
			if doneSelected == 0:
				get_tree().paused = false
				GameData.reset()
				get_tree().reload_current_scene()
			elif doneSelected == 1:
				returnToMenu()
		
		if scores.visible_characters < len(scores.text)- 10:
			if scoreTypes.visible_characters < len(scoreTypes.text):
				if timeAddChar <= 0:
					scoreTypes.visible_characters += 1
					timeAddChar = 0.025
				else:
					timeAddChar -= delta
			else:
				if timeAddChar <= 0:
					scores.visible_characters += 1
					timeAddChar = 0.15
					dink.play()
				else:
					timeAddChar -= delta


func _on_ActiveCamera_cameraMoved(vector):
	#move the rooms when camera moves
	for child in roomContainer.get_children():
		child.rect_position += vector * 16
		#toggle visibility
		if child.rect_position.x < 0 or child.rect_position.x > 128 or child.rect_position.y < 0 or child.rect_position.y > 128:
			child.visible = false
		else:
			child.visible = true



func _on_Player_ded():
	get_parent().get_parent().get_child(0).queue_free()
	get_tree().paused = true
	randomize()
	gameOver.play("animate")
	
	print(len(taunts))
	taunt.text = taunts[int(rand_range(1, len(taunts) + 0.9))]
	taunt.visible_characters = 0

func showScores():
	scores.text = str(GameData.playerCoins) + "\n\n" + str(GameData.enemiesKilled) + "\n\n" + str(GameData.playerHealth) + "\n\n" + str(GameData.sizes[GameData.size][0]) + "\n\n" + str(GameData.difficulties[GameData.difficulty])+ "\n\n" + str((GameData.playerCoins + GameData.enemiesKilled + GameData.playerHealth + GameData.sizes[GameData.size][0]) * GameData.difficulties[GameData.difficulty])


func returnToMenu():
	get_tree().paused = false
	GameData.reset()
	get_tree().change_scene("res://UserInterface/MainMenu.tscn")


func _on_MM_mouse_entered():
	if GameData.playerHealth <= 0 or ended:
		menuMove.play()
		doneSelected = 1
func _on_Restart_mouse_entered():
	if GameData.playerHealth <= 0 or ended:
		menuMove.play()
		doneSelected = 0


func _on_Restart_pressed():
	if GameData.playerHealth <= 0 or ended:
		get_tree().paused = false
		GameData.reset()
		get_tree().reload_current_scene()

func _on_MM_pressed():
	if GameData.playerHealth <= 0 or ended:
		returnToMenu()
