extends Control

var difficulty = ["normal", "hard", "expert"]
var difficultyIndex = 0
onready var difficultyLabel = $DifficultyLabel

var size = ["small", "medium", "large"]
var sizeIndex = 0
onready var sizeLabel = $SizeLabel

var selectedButton = 0

onready var arrow = $Border/Arrow


func _process(delta):
	arrow.rect_position.y = 208 + (80 * selectedButton)
	
	if Input.is_action_just_pressed("ui_up"):
		selectedButton -= 1
		if selectedButton < 0:
			selectedButton = 3
	if Input.is_action_just_pressed("ui_down"):
		selectedButton += 1
		if selectedButton > 3:
			selectedButton = 0
	
	if Input.is_action_just_pressed("interact"):
		if selectedButton == 0:
			start_game()
		elif selectedButton == 1:
			change_difficulty()
		elif selectedButton == 2:
			change_size()
		elif selectedButton == 3:
			get_tree().quit()
	
	
	

func change_size():
	sizeIndex += 1
	if sizeIndex > 2:
		sizeIndex = 0
	
	if size[sizeIndex] == "large":
		sizeLabel.modulate = Color(1, 0, 0, 1)
	else:
		sizeLabel.modulate = Color(1, 1, 1, 1)
	
	sizeLabel.text = "Dungeon Size : " + size[sizeIndex]

func change_difficulty():
	difficultyIndex += 1
	if difficultyIndex > 2:
		difficultyIndex = 0
	
	if difficulty[difficultyIndex] == "expert":
		difficultyLabel.modulate = Color(1, 0, 0, 1)
	else:
		difficultyLabel.modulate = Color(1, 1, 1, 1)
	
	difficultyLabel.text = "Difficulty : " + difficulty[difficultyIndex]

var level = load("res://World/Level.tscn")

func start_game():
	GameData.difficulty = difficulty[difficultyIndex]
	GameData.size = size[sizeIndex]
	get_tree().change_scene_to(level)



func _on_Start_mouse_entered():
	selectedButton = 0
func _on_Diffuculty_mouse_entered():
	selectedButton = 1
func _on_Size_mouse_entered():
	selectedButton = 2
func _on_Quit_mouse_entered():
	selectedButton = 3


func _on_Start_pressed():
	start_game()
func _on_Size_pressed():
	change_size()
func _on_Quit_pressed():
	get_tree().quit()
func _on_Diffuculty_pressed():
	change_difficulty()
