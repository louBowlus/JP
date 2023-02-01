extends Node

export var sizes = {
	"small" : [10, 15],
	"medium" : [20, 35],
	"large" : [40, 55]
}

export var size = "small"

export var difficulties = {
	"normal" : 1,
	"hard" : 2,
	"expert" : 3,
}
export var difficulty = "normal"

export var playerHealth = 10
export var playerStamina = 10

export var playerCoins = 0
export var enemiesKilled = 0

export var playerPos = Vector2.ZERO
export var playerDashed = false

export var roomPositions = []

export var finished = false

func reset():
	finished = false
	
	playerHealth = 10
	playerStamina = 10
	
	playerCoins = 0
	enemiesKilled = 0
	
	playerPos = Vector2.ZERO
	playerDashed = false
	
	roomPositions = []
