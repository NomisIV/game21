extends Node2D

const NUM_OF_POINTS = 14
const NAME_PREFIX = "TomatoSpawnPoint"
# Amount of time when the caviars should start blinking to warn about their despawn
const WARNING_TIME = 25
# Amount of time between the spawns
const SPAWN_TIME = 30
# Amount of caviars spawning during each spawn phase
const SPAWN_RATE = 7

var spawnPoints = []
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	loadSpawnPoints()
	
func _process(delta):
	# Spawn the first caviars
	if time == 0:
		spawnTomatoes()
	# Despawn the old caviars and spawn new ones when the time is met
	elif time > SPAWN_TIME:
		despawnTomatoes()
		spawnTomatoes()
	elif time > WARNING_TIME:
		warnTomatoes()
		
	time += delta
	
# Load in every spawn point up to the NUM_OF_POINTS
# Does not handle non-existent caviars so for the love of god,
# make sure NUM_OF_POINTS are correct and that they are correctly named.
func loadSpawnPoints():
	for i in range(1, NUM_OF_POINTS + 1):
		var pointName = NAME_PREFIX + str(i)
		var spawnPoint = getSpawnPointFromName(pointName)
		spawnPoints.append(spawnPoint)

# Spawn in the set amount of caviars at randomly choosen spawn points
func spawnTomatoes():
	var randSpawnPoints = getRandomSpawnPoints()
	for spawnPoint in randSpawnPoints:
		spawnPoint.spawnTomatoes()

# Despawn all caviars on the map
func despawnTomatoes():
	var randSpawnPoints = getRandomSpawnPoints()
	for spawnPoint in spawnPoints:
		if spawnPoint.hasTomato():
			spawnPoint.despawnTomatoes()
	time = 0

func warnTomatoes():
	for spawnPoint in spawnPoints:
		if spawnPoint.hasTomato():
			spawnPoint.doBlink()

# Get the caviar node from the string representation.
func getSpawnPointFromName(name):
	return get_parent().get_node(name)

# Get a SPAWN_RATE number of randomly choosen caviar spawn points.
func getRandomSpawnPoints():
	var spawnPoints = []
	
	for i in range(1, SPAWN_RATE + 1):
		var spawnPoint = NAME_PREFIX + str(int(rand_range(1, NUM_OF_POINTS + 1)))
		spawnPoint = getSpawnPointFromName(spawnPoint)
		# Absolutely garbage code, give me a do while for ffs
		while (spawnPoint in spawnPoints):
			spawnPoint = NAME_PREFIX + str(int(rand_range(1, NUM_OF_POINTS + 1)))
			spawnPoint = getSpawnPointFromName(spawnPoint)
		spawnPoints.append(spawnPoint)
	
	return spawnPoints
