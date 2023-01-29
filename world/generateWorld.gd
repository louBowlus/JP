extends Node2D

onready var tileMap = $TileMap
onready var floorMap = $Floor

#up down left right
var directions = {
	1 : Vector2.UP,
	2 : Vector2.DOWN,
	3 : Vector2.LEFT,
	4 : Vector2.RIGHT
}

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
	var farthestRoom = [0, Vector2.ZERO, null]
	
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

func _ready():
	generate(30, 35, 'easy', Vector2(0, 0), 640)

