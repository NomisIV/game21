extends Position2D

const CAVIAR = preload("res://caviar.tscn")
var spawnedCaviar = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawnCaviar():
	spawnedCaviar = weakref(CAVIAR.instance())
	spawnedCaviar.get_ref().global_position = self.global_position
	get_parent().get_parent().add_child(spawnedCaviar.get_ref())
	
func despawnCaviar():
	get_parent().get_parent().remove_child(spawnedCaviar.get_ref())
	spawnedCaviar = null
	

func doBlink():
	if spawnedCaviar.get_ref():
		spawnedCaviar.get_ref().doBlink()
	
func hasCaviar():
	return spawnedCaviar != null
