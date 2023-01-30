extends "res://Enemies/baseEnemyLogic.gd"

onready var splotchCont = $SplotchContainer
var splotch = load("res://Enemies/splotch.png")

func _ready():
	wanderRange = 200

func _process(delta):
	durdle(delta)
	
	splotchCont.global_position = Vector2(0, -7)
	for child in splotchCont.get_children():
		child.modulate.a -= delta
		if child.modulate.a <= 0:
			child.queue_free()

func add_splotch():
	var s = Sprite.new()
	s.scale /= 1.2
	s.texture = splotch
	s.position = global_position
	splotchCont.add_child(s)
	s.rotation_degrees = rand_range(0, 360)
	print(s.position)
	
