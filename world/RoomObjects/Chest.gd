extends StaticBody2D

var playerNear = false
var opened = false

func _ready():
	$Open.visible = false

#open chest
func _unhandled_input(event):
	if Input.is_action_just_pressed("interact") and playerNear and opened == false:
		opened = true
		$AnimationPlayer.play("open")

#prompt player to open chest
func _on_DetectPlayer_body_entered(body):
	playerNear = true
	if opened == false:
		$Open.visible = true

func _on_DetectPlayer_body_exited(body):
	playerNear = false
	if opened == false:
		$Open.visible = false
