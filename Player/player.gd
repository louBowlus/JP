extends KinematicBody2D



#movement here
const speed = 10000
const maxSpeed = 20000
const friction = 7000

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer

enum {
	MOVE,
	DASH,
	
}

var state = MOVE
var dashVector = Vector2.ZERO

onready var fadeContainer = $FadeContainer
var playerSprite = preload("res://icon.png")
var fades = []

func _physics_process(delta):
	var a = Vector2.ZERO
	
	a.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	a.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")\
	
	match state:
		MOVE:
			if Input.is_action_just_pressed("dash") and a != Vector2.ZERO:
				animationPlayer.play("dash")
				dashVector = a
				state = DASH
				
			
			a = a.normalized()
			
			velocity += a * speed * delta
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			velocity.x = clamp(velocity.x, -maxSpeed * delta, maxSpeed * delta)
			velocity.y = clamp(velocity.y, -maxSpeed * delta, maxSpeed * delta)
			
			velocity = move_and_slide(velocity)
			
		DASH:
			for child in fadeContainer.get_children():
				child.modulate.a -= 0.10
				if child.modulate.a <= 0:
					child.queue_free()
				print(child.modulate)
			
			velocity = dashVector * maxSpeed * delta * 2
			velocity += a * 100
			velocity = move_and_slide(velocity)
		
			if fadeContainer.get_child_count() == 0:
				state = MOVE
				dashVector = Vector2.ZERO



func addFade():
	var s = Sprite.new()
	s.texture = playerSprite
	s.global_position = global_position
	fadeContainer.add_child(s)
	#s.modulate.r = 0
	#s.modulate.g = 0
	#s.modulate.b = 0
	
