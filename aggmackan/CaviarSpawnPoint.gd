extends Position2D

const CAVIAR = preload("res://caviar.tscn")
var spawnedCaviar = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawnCaviar():
	spawnedCaviar = CAVIAR.instance()
	spawnedCaviar.global_position = self.global_position
	get_parent().get_parent().add_child(spawnedCaviar)
	
func despawnCaviar():
	get_parent().get_parent().remove_child(spawnedCaviar)
	spawnedCaviar = null
	
func hasCaviar():
	spawnedCaviar != null
