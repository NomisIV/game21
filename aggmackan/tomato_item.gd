extends Area2D

const BLINK_COLOR = Color(1,0.5,0.5)
const BLINK_INTERVALL = 0.4	
var time = 0
var doBlink = false
var isColorChanged = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):
	for body in get_overlapping_bodies():
		if body.has_method("pick_up_tomato"):
			body.pick_up_tomato();
			queue_free()
	if(doBlink):
		doBlink()
		
func doBlink():
	doBlink = true

func blink(delta):
	if time > BLINK_INTERVALL:
		# Reset the color
		if isColorChanged:
			$Sprite.modulate = Color(1, 1, 1)
		else:
			$Sprite.modulate = BLINK_COLOR
		isColorChanged = !isColorChanged
		time = 0
	time += delta
	
