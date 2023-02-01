extends Area2D

func _on_Portal_body_entered(body):
	GameData.finished = true
