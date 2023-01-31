extends "res://Enemies/baseEnemyLogic.gd"

export var speed = 3000
onready var splotchCont = $SplotchContainer
var splotch = load("res://Enemies/splotch.png")
export var shootDistance = 200
export var shootCooldown = 3

var shot = load("res://Enemies/SlimeShot.tscn")

var coolingRemaining = 0

func _physics_process(delta):
	
	if hitStun <=0:
		durdle(delta)
	else:
		hitStun -= delta
		velocity = velocity.move_toward(Vector2.ZERO, 100)
		velocity = move_and_slide(velocity)
	
	splotchCont.global_position = Vector2(0, -7)
	for child in splotchCont.get_children():
		if 'Sprite' in str(child):
			child.modulate.a -= delta
			if child.modulate.a <= 0:
				child.queue_free()
	
	match state:
		CHASE:
			if hitStun <= 0:
				coolingRemaining -= delta
				
				if global_position.distance_to(GameData.playerPos) > detectDistance:
					state = IDLE 
				
				velocity = global_position.direction_to(GameData.playerPos) * speed * delta
				velocity = move_and_slide(velocity)
			
			if global_position.distance_to(GameData.playerPos) <= shootDistance and coolingRemaining <= 0:
				coolingRemaining = shootCooldown
				#shoot
				var s1 = shot.instance()
				var s2 = shot.instance()
				s1.direction = "left"
				s2.direction = "right"
				s1.position = global_position
				s2.position = global_position
				splotchCont.add_child(s1)
				splotchCont.add_child(s2)
				


func add_splotch():
	var s = Sprite.new()
	s.scale /= 1.2
	s.texture = splotch
	s.position = global_position
	splotchCont.add_child(s)
	s.rotation_degrees = rand_range(0, 360)


func _on_HurtBox_area_entered(area):
	health -= 1
	knockBack(global_position, area.global_position)
