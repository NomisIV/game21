extends Position2D

const TOMATO = preload("res://tomato_item.tscn")
var spawnedTomato = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawnTomatoes():
	spawnedTomato = weakref(TOMATO.instance())
	spawnedTomato.get_ref().global_position = self.global_position
	get_parent().get_parent().add_child(spawnedTomato.get_ref())
	
func despawnTomatoes():
	get_parent().get_parent().remove_child(spawnedTomato.get_ref())
	spawnedTomato = null
	

func doBlink():
	if spawnedTomato.get_ref():
		spawnedTomato.get_ref().doBlink()
	
func hasTomato():
	return spawnedTomato != null
