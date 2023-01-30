extends "res://Enemies/baseEnemyLogic.gd"

export var speed = 2500

onready var anim = $AnimationPlayer

onready var eyes = $Eyes

func _physics_process(delta):
	durdle(delta)
	if velocity.x < 0:
		eyes.scale.x = -1
	elif velocity.x > 0:
		eyes.scale.x = 1
	
	match state:
		CHASE:
			velocity = global_position.direction_to(GameData.playerPos) * speed * delta
			
			velocity = move_and_slide(velocity)
			
			anim.play("chase")
			
			if global_position.distance_to(GameData.playerPos) > detectDistance:
				anim.play("walk")
				state = IDLE 
			
	

