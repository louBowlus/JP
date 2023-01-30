extends "res://Enemies/baseEnemyLogic.gd"

export var speed = 1000
onready var phantom = $Phantom
onready var hitBox = $HitBox
onready var shadow = $Small

var num = 0

func _process(delta):
	durdle(delta)
	
	match state:
		CHASE:
			phantom.visible = true
			
			var vecDifference = GameData.playerPos - global_position
			
			phantom.global_position = GameData.playerPos + vecDifference
			
			if num % 2 == 0:
				hitBox.global_position = phantom.global_position
				shadow.global_position = phantom.global_position + Vector2(0.5, 26.5)
			else:
				hitBox.global_position = global_position + Vector2(0, -40)
				shadow.global_position = global_position + Vector2(0.5, -1.5)
			
			
			if global_position.distance_to(GameData.playerPos) > detectDistance:
				state = IDLE
				num += 1
			
			velocity = global_position.direction_to(GameData.playerPos) * speed * delta
			velocity = move_and_slide(velocity)
		IDLE:
			phantom.visible = false
			hitBox.global_position = global_position + Vector2(0, -40)
			shadow.global_position = global_position + Vector2(0.5, -1.5)
		WANDER:
			phantom.visible = false
			hitBox.global_position = global_position + Vector2(0, -40)
			shadow.global_position = global_position + Vector2(0.5, -1.5)


