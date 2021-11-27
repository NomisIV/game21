extends KinematicBody2D
const MAX_SHOTS = 5
const FIRE_RATE_TIME = 1
const BURST_RATE_TIME = 0.1
const Fireball = preload("res://fireball.tscn")
onready var player = get_parent().get_node("Player")
var vel : Vector2 = Vector2()
var astar = AStar.new()
var pos
var test = false

enum Mode {
	PATROL,
	TRACK
}

var doing_burst = false
var shots_in_burst = MAX_SHOTS
var fire_rate = FIRE_RATE_TIME
var burst_rate = BURST_RATE_TIME

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _physics_process(delta):
	do_burst(delta)
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

func do_burst(delta):
	if doing_burst or fire_rate > FIRE_RATE_TIME:
		if !doing_burst:
			shots_in_burst = MAX_SHOTS
			doing_burst = true
		if shots_in_burst > 0 and burst_rate > BURST_RATE_TIME:
			shoot_fire_towards(get_parent().get_node("Player").global_position)
			shots_in_burst -= 1
			burst_rate = 0
		else:
			burst_rate += delta
		if shots_in_burst <= 0:
			doing_burst = false
			fire_rate = 0
	else:
		fire_rate += delta
		
		
func shoot_fire_towards(target):
	var fireball = Fireball.instance()
	get_parent().add_child(fireball)
	fireball.transform = global_transform
	fireball.look_at(target)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
