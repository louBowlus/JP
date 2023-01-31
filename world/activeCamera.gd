extends Camera2D

onready var moveTween = $MoveTween

signal cameraMoved

var timeRemaining = 0
var currentShakeStr = 0
var dshStr = 0.5

func startShake(duration, strength):
	timeRemaining = duration
	currentShakeStr = strength

#move camera based off of where players is
func _process(delta):
	
	#move camera
	if GameData.playerPos.y > global_position.y + 320:
		moveTween.interpolate_property(self, "global_position", null, global_position + Vector2(0, 640), 0.1, 1)
		emit_signal("cameraMoved", Vector2.UP)
	elif GameData.playerPos.y < global_position.y - 320:
		moveTween.interpolate_property(self, "global_position", null, global_position - Vector2(0, 640), 0.1, 1)
		emit_signal("cameraMoved", Vector2.DOWN)
	elif GameData.playerPos.x < global_position.x - 320:
		moveTween.interpolate_property(self, "global_position", null, global_position - Vector2(640, 0), 0.1, 1)
		emit_signal("cameraMoved", Vector2.RIGHT)
	elif GameData.playerPos.x > global_position.x + 320:
		moveTween.interpolate_property(self, "global_position", null, global_position + Vector2(640, 0), 0.1, 1)
		emit_signal("cameraMoved", Vector2.LEFT)
	
	moveTween.start()
	
	#shake camera
	if GameData.playerDashed:
		startShake(0.3, dshStr)
		GameData.playerDashed = false
	
	#limit time
	if timeRemaining > 0:
		self.offset = Vector2(rand_range(-currentShakeStr,currentShakeStr),rand_range(-currentShakeStr, currentShakeStr))
		timeRemaining -= delta
		if timeRemaining <= 0:
			self.offset = Vector2.ZERO
	


func _on_Player_cameraShake(duration, strength):
	startShake(duration, strength)
