extends Control

onready var tween = $BarTween
onready var healthBar = $Health/Bar

onready var roomContainer = $Map/Rooms
var square = load("res://UserInterface/square.png")

func _ready():
	while GameData.roomPositions == []:
		pass
	
	for room in GameData.roomPositions:
		#make rooms
		var roomVector = room / 640
		var sqr = TextureRect.new()
		sqr.texture = square
		sqr.rect_position = Vector2(48, 48) + (roomVector * 16)
		roomContainer.add_child(sqr)
		
		#toggle visibility of rooms too far on map
		if sqr.rect_position.x < 0 or sqr.rect_position.x > 72 or sqr.rect_position.y < 0 or sqr.rect_position.y > 72:
			sqr.visible = false
		else:
			sqr.visible = true

func _process(delta):
	#show health and change color of bar
	tween.interpolate_property(healthBar, "rect_size", null, Vector2(GameData.playerHealth * 10, 4), 0.2, 1)
	tween.interpolate_property(healthBar, "color", null, Color(1 - (GameData.playerHealth / 10), GameData.playerHealth / 5, 0, 1), 0.2, 1)
	tween.start()
	if GameData.playerHealth <= 3:
		$LowHealth.play("pulse")
	
	


func _on_ActiveCamera_cameraMoved(vector):
	#move the rooms when camera moves
	for child in roomContainer.get_children():
		child.rect_position += vector * 16
		#toggle visibility
		if child.rect_position.x < 0 or child.rect_position.x > 2 * 48 or child.rect_position.y < 0 or child.rect_position.y > 2 * 48:
			child.visible = false
		else:
			child.visible = true
