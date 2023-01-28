extends Node2D

#up, down, left right
export var doors = {
	4 : false,
	2 : false,
	3 : false,
	1 : false,
}

var door = preload("res://world/Door.tscn")

func _ready():
	for i in doors:
		if doors[i] == true:
			var d = door.instance()
			self.add_child(d)
			d.rotation_degrees = 90 * i
			d.direction = i
			
		
		

