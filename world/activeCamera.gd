extends Camera2D

onready var moveTween = $MoveTween
#move camera based off of where players is
func _process(delta):
	
	
	if GameData.playerPos.y > global_position.y + 300:
		moveTween.interpolate_property(self, "global_position", null, global_position + Vector2(0, 600), 0.1, 1)
	elif GameData.playerPos.y < global_position.y - 300:
		moveTween.interpolate_property(self, "global_position", null, global_position - Vector2(0, 600), 0.1, 1)
	elif GameData.playerPos.x < global_position.x - 300:
		moveTween.interpolate_property(self, "global_position", null, global_position - Vector2(600, 0), 0.1, 1)
	elif GameData.playerPos.x > global_position.x + 300:
		moveTween.interpolate_property(self, "global_position", null, global_position + Vector2(600, 0), 0.1, 1)
	
	moveTween.start()
