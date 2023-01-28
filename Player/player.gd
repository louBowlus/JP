extends KinematicBody2D

#movement here
const speed = 5000
const maxSpeed = 10000
const friction = 3500

var velocity = Vector2.ZERO

#animation nodes
onready var animationPlayer = $AnimationPlayer
onready var dashPlayer = $DashPlayer

#state tracking
enum {
	MOVE,
	DASH,
}

var state = MOVE
var dashVector = Vector2.ZERO

#sprite fading
onready var fadeContainer = $FadeContainer
var playerSprite = preload("res://Player/base.png")
onready var sprite = $Icon

func _physics_process(delta):
	#get input
	var a = Vector2.ZERO
	
	GameData.playerPos = global_position
	
	a.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	a.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	a = a.normalized()
	
	#flip sprite
	if a.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	match state:
		MOVE:
			#dash
			if Input.is_action_just_pressed("dash") and a != Vector2.ZERO:
				dashPlayer.play("dash")
				dashVector = a
				state = DASH
				
			
			#animate
			if a == Vector2.ZERO:
				animationPlayer.play("idle")
			else:
				animationPlayer.play("run")
			
			
			#acceleration and friction
			velocity += a * speed * delta
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			velocity.x = clamp(velocity.x, -maxSpeed * delta, maxSpeed * delta)
			velocity.y = clamp(velocity.y, -maxSpeed * delta, maxSpeed * delta)
			
			velocity = move_and_slide(velocity)
			
		DASH:
			#make all of the afterimages fade
			for child in fadeContainer.get_children():
				child.modulate.a -= 0.20
				if child.modulate.a <= 0:
					child.queue_free()
			
			#player can manipulate the dash direction a little bit
			velocity = dashVector * maxSpeed * delta * 2
			velocity += a * 200
			velocity = move_and_slide(velocity)
		
		#if all fades gone, then stop the dash
			if fadeContainer.get_child_count() == 0:
				state = MOVE
				dashVector = Vector2.ZERO



func addFade():
	#make a sprite a child of a Node to stay in place without following the player
	var s = Sprite.new()
	s.texture = playerSprite
	s.scale *= self.scale
	s.global_position = global_position
	fadeContainer.add_child(s)
	s.flip_h = sprite.flip_h
	
