extends KinematicBody2D

enum {
	IDLE,
	WANDER,
	CHARGE,
}

var time = 0
var maxTime = 0
var state = IDLE

var originalPosition = Vector2.ZERO
var wanderPosition = Vector2.ZERO
var distance = 0

var speed = 500
var velocity = Vector2.ZERO

onready var sprite = $Sprite

func _ready():
	time = rand_range(2, 6)
	originalPosition = global_position

func durdle(delta):
	match state:
		IDLE:
			time -= delta
			if time <= 0:
				switchWanderIdle()
		WANDER:
			time -= delta
			if time <= 0:
				state = IDLE
				time = 2
			
			
			
			velocity = wanderPosition - global_position
			
			if velocity.x < 0:
				sprite.flip_h = true
			elif velocity.x > 0:
				sprite.flip_h = false
			
			velocity = move_and_slide(velocity)
		CHARGE:
			pass

var wanderRange = 75

func switchWanderIdle():
	
	
	
	randomize()
	print('----------------')
	var sL = [IDLE, WANDER]
	sL.shuffle()
	
	state = WANDER
	if state == WANDER:
		var a = Vector2(rand_range(-wanderRange, wanderRange), rand_range(-wanderRange, wanderRange))
		print("offset from start by : ", a)
		wanderPosition = originalPosition + a
		distance = wanderPosition.distance_to(global_position)
		
		print(state, wanderPosition)
		print("wander to : ", wanderPosition)
		
		
	time = rand_range(2, 4)
	maxTime = time

