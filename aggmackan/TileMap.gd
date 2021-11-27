extends TileMap

var astar
var size

# Called when the node enters the scene tree for the first time.
func _ready():
	astar = AStar2D.new()
	# Get an estimate of the map size
	size = get_used_rect().size
	# Reserve a sufficient amount of space
	astar.reserve_space(size.x * size.y)
	initAStarMap()

# Initialize the pathfinding algorithm
func initAStarMap():
	addAStarPoints()

# Add every map tile to AStar
func addAStarPoints():
	for y in size.y:
		for x in size.x:
			var vector = Vector2(x, y)
			var id = getAStarCellById(vector)
			astar.add_point(id, map_to_world(vector))

# Connect the points that are valid 
func connectAStarPoints():
	for y in size.y:
		for x in size.x:
			var id = getAStarCellById(Vector2(x, y))
			
			# Calculate every neighbour of the point
			var neighbours = [
				Vector2(x, y-1), Vector2(x, y+1),
				Vector2(x-1, y), Vector2(x+1,y),
				Vector2(x-1, y-1), Vector2(x-1, y+1), 
				Vector2(x+1, y-1), Vector2(x+1, y+1)
				]
			
			for neighbour in neighbours:
				var idNeighbour = getAStarCellById(Vector2(x, y))
				# Check if the point exists in the AStar mapping
				if astar.has_point(idNeighbour):
					# Connect the two points. This has to be changed
					# for objects that are larger than one tile and cannot
					# move too close to the edges.
					astar.connect_points(id, idNeighbour, false)

# Mark an AStar cell as occupied
func occupyAStarCell(globalPos:Vector2):
	changeCellStatus(globalPos, false)

# Mark an AStar cell as unoccupied
func freeAStarCell(globalPos:Vector2):
	changeCellStatus(globalPos, true)

# Change a cell's status to either occuped or unnocupied
func changeCellStatus(globalPos:Vector2, state:bool):
	var cell = self.world_to_map(globalPos)
	var id = getAStarCellById(cell)
	
	if astar.has_points(id):
		astar.set_point_disabled(state)

func getAStarCellById(vCell:Vector2):
	return vCell.y + (vCell.x * size.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
