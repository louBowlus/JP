extends Node2D

export var targetPosition = Vector2.ZERO
export var direction = "left"

var startingComplete = false
var speed = 400

var lifeTime = 3

onready var anim = $AnimationPlayer

var veloctiy = Vector2.ZERO

func _ready():
	anim.play(direction)

onready var sprite = $Sprite

var vect = Vector2.ZERO

func _process(delta):
	if startingComplete:
		veloctiy = vect * (speed+ (100 * GameData.difficulties[GameData.difficulty])) * delta
		sprite.position += veloctiy
		
		lifeTime -= delta
		if lifeTime <= 0:
			queue_free()
		

func onStartFin():
	startingComplete = true
	vect = sprite.global_position.direction_to(GameData.playerPos)
	sprite.rotation = global_position.angle_to(targetPosition)
	
	



func _on_Area2D_body_entered(body):
	lifeTime = 0
