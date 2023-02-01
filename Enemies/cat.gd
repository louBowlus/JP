extends "res://Enemies/baseEnemyLogic.gd"

export var speed = 2500

onready var anim = $AnimationPlayer

onready var eyes = $Eyes

func _ready():
	speed = speed + (1000 * GameData.difficulties[GameData.difficulty])
	

func _physics_process(delta):
	if hitStun <= 0:
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
				
	else:
		hitStun -= delta
		velocity = velocity.move_toward(Vector2.ZERO, 100)
		velocity = move_and_slide(velocity)

var death = load("res://Enemies/Death.tscn")

onready var hitSfx = $HitSfx

func _on_HurtBox_area_entered(area):
	
	health -= 1
	knockBack(global_position, area.global_position)
	if health <= 0:
		var d = death.instance()
		get_parent().add_child(d)
		d.global_position = global_position + Vector2(0, -8)
		d.scale *= 1
		GameData.enemiesKilled += 1
		queue_free()
	hitSfx.play()
