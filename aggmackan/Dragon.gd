extends KinematicBody2D

onready var player = get_parent().get_node("Player")
var vel : Vector2 = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	vel.x = rand_range(-2, 2)
	vel.y = rand_range(-2, 2)
	move_and_collide(vel)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
