extends "res://Enemies/baseEnemyLogic.gd"

export var speed = 1000
onready var splotchCont = $SplotchContainer
var splotch = load("res://Enemies/splotch.png")
export var shootDistance = 200
export var shootCooldown = 3

var coolingRemaining = 0

func _physics_process(delta):
	durdle(delta)
	
	splotchCont.global_position = Vector2(0, -7)
	for child in splotchCont.get_children():
		child.modulate.a -= delta
		if child.modulate.a <= 0:
			child.queue_free()
	
	match state:
		CHASE:
			coolingRemaining -= delta
			
			if global_position.distance_to(GameData.playerPos) > detectDistance:
				state = IDLE 
			
			velocity = global_position.direction_to(GameData.playerPos) * speed * delta
			velocity = move_and_slide(velocity)
			
			if global_position.distance_to(GameData.playerPos) <= shootDistance and coolingRemaining <= 0:
				coolingRemaining = shootCooldown
				#shoot
				


func add_splotch():
	var s = Sprite.new()
	s.scale /= 1.2
	s.texture = splotch
	s.position = global_position
	splotchCont.add_child(s)
	s.rotation_degrees = rand_range(0, 360)
	print(s.position)
	
