extends Node2D

export var targetPosition = Vector2.ZERO
export var direction = "left"

var startingComplete = false

onready var sprite = $Sprite

func _process(delta):
	pass
	
	

func onStartFin():
	startingComplete = true
	sprite.rotation = global_position.direction_to(targetPosition)
	
	
