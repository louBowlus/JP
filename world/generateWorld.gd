extends Node2D

var directions = {
	1 : Vector2.UP,
	2 : Vector2.DOWN,
	3 : Vector2.LEFT,
	4 : Vector2.RIGHT
}

func generate(minRooms, maxRooms, difficulty, startingRoomPos, roomSize):
	var random = RandomNumberGenerator.new()
	random.randomize()
	var roomNumber = random.randi_range(minRooms, maxRooms)
	
	var roomPoints = [startingRoomPos]
	
	
	var startingRoom = Node2D.new()
	startingRoom.global_position=roomPoints[0]
	self.add_child(startingRoom)
	
	for i in range(roomNumber - 1):
		var room = Node2D.new()
		var direction = random.randi_range(1, 4)
		room.global_position = roomPoints[len(roomPoints)-1]
		room.global_position += directions[direction] * roomSize
		roomPoints.append(room.global_position)
		self.add_child(room)
	
	var farthestRoom = [0, Vector2.ZERO, null]
	
	var line = Line2D.new()
	for point in roomPoints:
		print(point)
		line.add_point(point)
		var sprite = Sprite.new()
		sprite.texture = load("res://world/roomStencil.png")
		if point == Vector2.ZERO:
			sprite.modulate = Color(0, 0, 1,1)
		else:
			sprite.modulate = Color(0, 0, 0, 1)
		self.add_child(sprite)
		sprite.global_position = point
		sprite.scale *= (600/64)
		if point.distance_to(Vector2.ZERO) > farthestRoom[0]:
			farthestRoom[0] = point.distance_to(Vector2.ZERO)
			farthestRoom[1] = point
			farthestRoom[2] = sprite
			
	
	farthestRoom[2].modulate = Color(1, 0, 0, 1)
	
	
	add_child(line)

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		for child in self.get_children():
			if not 'Camera2D' in str(child):
				child.queue_free()
		generate(10, 15, 'easy', Vector2(0, 0), 600)
	
