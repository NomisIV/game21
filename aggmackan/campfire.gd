extends Area2D

onready var collisionBox = get_node("CollisionShape2D")



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in get_overlapping_bodies():
		if body.has_method("drop_of_egg"):
			body.drop_of_egg()

