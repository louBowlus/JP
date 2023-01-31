extends KinematicBody2D

#movement here
const speed = 5000
const maxSpeed = 10000
const friction = 3500

var velocity = Vector2.ZERO

#animation nodes
onready var animationPlayer = $AnimationPlayer
onready var dashPlayer = $DashPlayer
onready var swordPlayer = $SwordPivot/AnimationPlayer
onready var swordPivot = $SwordPivot

signal cameraShake

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

var b = Vector2.ZERO


func _physics_process(delta):
	#get input
	var a = Vector2.ZERO
	
	GameData.playerPos = global_position
	
	a.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	a.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	var r = 0
	
	if a != Vector2.ZERO:
		b = a
	
	if b.x > 0 and b.y > 0:
		#down-right
		r = 45 + 270
	elif a.x > 0 and b.y < 0:
		#up-right
		r = 180 + 45
	elif b.x < 0 and b.y > 0:
		#down-left
		r = 45
	elif b.x < 0 and b.y < 0:
		#up left
		r = 180 - 45
	elif b.x > 0 and b.y == 0:
		#right
		r = 270
	elif b.x < 0 and b.y == 0:
		#left
		r = 90
	elif b.x == 0 and b.y > 0:
		#down
		r = 0
	elif b.x == 0 and b.y < 0:
		#up
		r = 180
	
	
	
	a = a.normalized()
	
	#flip sprite
	if a.x < 0:
		sprite.flip_h = true
	elif a.x > 0:
		sprite.flip_h = false
	
	match state:
		MOVE:
			if Input.is_action_just_pressed("attack") and swordPlayer.is_playing() == false:
				swordPivot.rotation_degrees = r
				swordPlayer.play("Swing")
				emit_signal("cameraShake", 0.1, 0.75)
			
			
			#dash
			if Input.is_action_just_pressed("dash") and a != Vector2.ZERO and GameData.playerStamina >= 1 and swordPlayer.is_playing() == false:
				GameData.playerStamina -= 1
				dashPlayer.play("dash")
				GameData.playerDashed = true
				dashVector = a
			
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
	state = DASH
	#make a sprite a child of a Node to stay in place without following the player
	var s = Sprite.new()
	s.texture = playerSprite
	s.scale *= self.scale
	s.global_position = $DashPos.global_position
	fadeContainer.add_child(s)
	s.flip_h = sprite.flip_h
	


func _on_HurtBox_area_entered(area):
	GameData.playerHealth -= area.damage
	velocity = global_position.direction_to(area.global_position) * -10000
	$HurtBox/flash.play("flash")
