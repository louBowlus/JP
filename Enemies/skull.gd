extends "res://Enemies/baseEnemyLogic.gd"

export var speed = 1000
onready var phantom = $Phantom
onready var hitBox = $HitBox
onready var shadow = $Small

var num = 0
var initialDistance = 0

func _process(delta):
	
	
	match state:
		CHASE:
			if hitStun <= 0:
				speed = 100
				phantom.visible = true
				
				var vecDifference = GameData.playerPos - global_position
				
				if num % 2 == 0:
					hitBox.global_position = phantom.global_position
					shadow.global_position = phantom.global_position + Vector2(0.5, 26.5)
				else:
					hitBox.global_position = global_position + Vector2(0, -40)
					shadow.global_position = global_position + Vector2(0.5, -1.5)
				
				
				if global_position.distance_to(GameData.playerPos) > detectDistance:
					state = IDLE
					num += 1
				
				if global_position.y != GameData.playerPos.y +21:
					global_position.y = move_toward(global_position.y, GameData.playerPos.y + 21, speed)
				
				global_position.x = move_toward(global_position.x, GameData.playerPos.x, speed * delta)
				phantom.global_position.x = move_toward(phantom.global_position.x, GameData.playerPos.x, speed * delta * 2)
				
			else:
				hitStun -= delta
				
				if global_position.x > GameData.playerPos.x:
					global_position.x += (speed / 4) * delta * 10
				else:
					global_position.x -= (speed / 4) * delta * 10
				
				if phantom.global_position.x > GameData.playerPos.x:
					phantom.global_position.x += (speed / 4) * delta * 2 * 10
				else:
					phantom.global_position.x -= (speed / 4) * delta * 2 * 10
				
				if num % 2 == 0:
					hitBox.global_position = phantom.global_position
					shadow.global_position = phantom.global_position + Vector2(0.5, 26.5)
				else:
					hitBox.global_position = global_position + Vector2(0, -40)
					shadow.global_position = global_position + Vector2(0.5, -1.5)
				
		IDLE:
			durdle2(delta)
		WANDER:
			durdle2(delta)
	
	durdle(delta)


func durdle2(delta):
	if global_position.distance_to(GameData.playerPos) <= detectDistance:
		if global_position.x < GameData.playerPos.x:
			global_position.x = GameData.playerPos.x - 150
			phantom.global_position.x = GameData.playerPos.x + 150
		elif global_position.x > GameData.playerPos.x:
			global_position.x = GameData.playerPos.x + 150
			phantom.global_position.x = GameData.playerPos.x + 150
		
		state = CHASE
	initialDistance = GameData.playerPos.x - global_position.x
	phantom.global_position.x = GameData.playerPos.x + initialDistance
	phantom.visible = false
	hitBox.global_position = global_position + Vector2(0, -40)
	shadow.global_position = global_position + Vector2(0.5, -1.5)

func _on_HurtBox_area_entered(area):
	hitStun = 0.25
	health -= 1
	num += int(rand_range(0, 3))
	if health <= 0:
		queue_free()




func _on_HitBox_body_entered(body):
	hitStun = 0.25
	speed = 200
	num += 1
