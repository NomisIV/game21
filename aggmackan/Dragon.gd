extends KinematicBody2D

onready var player = get_parent().get_node("Player")
onready var tileMap = get_parent().get_node("Map").get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _physics_process(delta):
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
