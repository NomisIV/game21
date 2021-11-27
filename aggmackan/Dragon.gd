extends KinematicBody2D

onready var player = get_parent().get_node("Player")
var vel : Vector2 = Vector2()
var astar = AStar.new()
var pos
var test = false

enum Mode {
	PATROL,
	TRACK
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _physics_process(delta):
	# Only for filthy testing
	if (not test):
		test = true
		track()
	
func track():
	pos = self.global_position
	
	# The dragons current position
	astar.add_point(1, Vector3(0, 0, 0))
	astar.add_point(2, Vector3(0, 1, 0))
	astar.add_point(3, Vector3(1, 1, 0))
	astar.add_point(4, Vector3(0, 0, 0))
	
	astar.connect_points(1, 2, false)
	astar.connect_points(2, 3, false)
	astar.connect_points(10, 3, false)
	astar.connect_points(1, 4, false)
	var res = astar.get_id_path(1, 3)
	print (res)
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
