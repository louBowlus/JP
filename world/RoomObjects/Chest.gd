extends StaticBody2D

var playerNear = false
var opened = false

func _ready():
	randomize()
	$Open.visible = false

#open chest
func _unhandled_input(event):
	if Input.is_action_just_pressed("interact") and playerNear and opened == false:
		opened = true
		GameData.playerCoins += int(rand_range(3, 7 + (4 * GameData.difficulties[GameData.difficulty])))
		GameData.playerStamina += int(rand_range(2, 4 + (3 * GameData.difficulties[GameData.difficulty])))
		GameData.playerHealth += int(rand_range(1, 3 + (2 * GameData.difficulties[GameData.difficulty])))
		
		GameData.playerHealth = clamp(GameData.playerHealth, 0, 10)
		GameData.playerStamina = clamp(GameData.playerStamina, 0, 10)
		
		
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
