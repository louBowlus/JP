extends Node2D

onready var tileMap = $TileMap
onready var floorMap = $Floor

var chest = load("res://World/RoomObjects/Chest.tscn")

var roomObjects = {
	1 : load("res://World/RoomObjects/Bush.tscn"),
	3 : load("res://World/RoomObjects/Crate.tscn"),
	4 : load("res://World/RoomObjects/PalmTree.tscn"),
	2 : load("res://World/RoomObjects/Torch.tscn"),
}

var enemies = {
	3 : load("res://Enemies/Cat.tscn"),
	2 : load("res://Enemies/Skull.tscn"),
	1 : load("res://Enemies/Slime.tscn"),
}

var completedRooms = [Vector2.ZERO]

#up down left right
var directions = {
	1 : Vector2.UP,
	2 : Vector2.DOWN,
	3 : Vector2.LEFT,
	4 : Vector2.RIGHT
}

var portal = load("res://World/Portal.tscn")

var farthestRoom = []

func drawWalls(roomPosition, allRooms, roomSize):
	#generate four walls for the room
	
	#account for the size of the tiles
	var r = roomPosition / 32
	
	var surroundingRooms = {
		Vector2.UP : false,
		Vector2.DOWN : false,
		Vector2.LEFT : false,
		Vector2.RIGHT : false,
	}
	
	#floor
	for x in range(-9, 9, 1):
		for y in range(-9, 9, 1):
			var j = int(rand_range(0, 19.9))
			if j > 10:
				floorMap.set_cell(x + r.x, y + r.y, j - 10)
			else:
				floorMap.set_cell(x + r.x, y + r.y, 0)
	
	
	for j in range(2):
		#top and bottom
		for i in range(-10, 10, 1):
			tileMap.set_cell(i + r.x, (j * 19) - 10 + r.y, 0)
	
	for j in range(2):
		#left and right
		for i in range(-10, 10, 1):
			tileMap.set_cell((j * 19) - 10 + r.x, i + r.y, 0)
	
	#create doors
	for room in allRooms:
		if room != roomPosition:
			#loop through all directions
			for i in surroundingRooms:
				#if a room is adjacent, change it to true
				if roomPosition + (i * roomSize) == room:
					surroundingRooms[i] = true
	
	#unoptimized and jank way to carve holes in the wall
	if surroundingRooms[Vector2.UP] == true:
		for i in range(-4, 4, 1):
			tileMap.set_cell(i + r.x, -10 + r.y, -1)
			floorMap.set_cell(i + r.x, -10 + r.y, 0)
	
	if surroundingRooms[Vector2.DOWN] == true:
		for i in range(-4, 4, 1):
			tileMap.set_cell(i + r.x, 9 + r.y, -1)
			floorMap.set_cell(i + r.x, 9 + r.y, 0)
	
	if surroundingRooms[Vector2.LEFT] == true:
		for i in range(-4, 4, 1):
			tileMap.set_cell(-10 + r.x, r.y + i, -1)
			floorMap.set_cell(-10 + r.x, r.y + i, 0)
	
	if surroundingRooms[Vector2.RIGHT] == true:
		for i in range(-4, 4, 1):
			tileMap.set_cell(9 + r.x, r.y + i, -1)
			floorMap.set_cell(9 + r.x, r.y + i, 0)
	


func generate(minRooms, maxRooms, difficulty, startingRoomPos, roomSize):
	#generate a random amount of rooms
	var random = RandomNumberGenerator.new()
	random.randomize()
	var roomNumber = random.randi_range(minRooms, maxRooms)
	
	var roomPoints = [startingRoomPos]
	
	#make a starting room
	var startingRoom = Node2D.new()
	startingRoom.global_position=roomPoints[0]
	self.add_child(startingRoom)
	
	
	for i in range(roomNumber - 1):
		#choose a random direction from the previous room and add a room
		var room = Node2D.new()
		var direction = random.randi_range(1, 4)
		room.global_position = roomPoints[len(roomPoints)-1]
		room.global_position += directions[direction] * roomSize
		roomPoints.append(room.global_position)
		self.add_child(room)
	
	#distance, room coords, and sprite instance
	farthestRoom = [0, Vector2.ZERO, null]
	
	var line = Line2D.new()
	for point in roomPoints:
		#add walls
		drawWalls(point, roomPoints, roomSize)
		
		#calculate farthest room from the room at 0, 0
		if point.distance_to(Vector2.ZERO) > farthestRoom[0]:
			farthestRoom[0] = point.distance_to(Vector2.ZERO)
			farthestRoom[1] = point
	
	#update bitmask to make it autotile correctly
	tileMap.update_bitmask_region(Vector2(-1000, -1000), Vector2(1000, 1000))
	GameData.roomPositions = roomPoints
	
	for room in roomPoints:
		print(room)
		if room in completedRooms:
			pass
		else:
			completedRooms.append(room)
			
			if int(rand_range(1, 4)) > 2 and room != farthestRoom[1]:
				var c = chest.instance()
				c.global_position = room + Vector2(rand_range(-10, 10), rand_range(-10, 10))
				get_child(3).add_child(c)
			
			#for each corner
			for i in range(4):
				#if 1, do two of 1 object. if 2, do 1 of two objects. if 3, do two of one and 1 of another.
				var numberObj = int(rand_range(1, 3.9))
				
				var obj1 = int(rand_range(1, 4.9))
				var obj2 = int(rand_range(1, 4.9))
				
				#get where to start placing from
				var cornerStarting = getCornerDist(i, 256, room, 5)
				
				var s = roomObjects[obj1].instance()
				s.global_position = cornerStarting
				get_child(3).add_child(s)
				
				if numberObj > 1:
					if numberObj > 2:
						var p = roomObjects[obj1].instance()
						p.global_position = getCornerDist(i, 100, room, 75)
						get_child(3).add_child(p)
					var dist = getCornerDist(i, 186, room, 50)
					var k = roomObjects[obj2].instance()
					
					
					if rand_range(0, 3 + (GameData.difficulties[GameData.difficulty] * 2)) > 3:
						#add an enemy
						var e = enemies[int(rand_range(1, 3.9))].instance()
						e.global_position = dist + Vector2(16, 16)
						get_child(3).add_child(e)
						
					
					k.global_position = dist
					get_child(3).add_child(k)
				
				
				
				pass
		
	
	
	var p = portal.instance()
	p.global_position = farthestRoom[1]
	add_child(p)
	

func getCornerDist(corner, distance, room, rng):
	var cornerStarting = Vector2.ZERO
	if corner == 0:
		cornerStarting = room + Vector2(-distance + rand_range(-rng, rng), -distance + rand_range(-rng, rng))
		#top right
	elif corner == 1:
		cornerStarting = room + Vector2(distance + rand_range(-rng, rng), -distance + rand_range(-rng, rng))
		#bottom left
	elif corner == 2:
		cornerStarting = room + Vector2(-distance + rand_range(-rng, rng), distance + rand_range(-rng, rng))
		#bottom right
	elif corner == 3:
		cornerStarting = room + Vector2(distance + rand_range(-rng, rng), distance + rand_range(-rng, rng))
	
	return cornerStarting
	


func _ready():
	generate(GameData.sizes[GameData.size][0], GameData.sizes[GameData.size][1], GameData.difficulties[GameData.difficulty], Vector2(0, 0), 640)
	print("------------------")
	print(GameData.size, GameData.difficulty)
