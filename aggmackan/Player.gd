extends KinematicBody2D


var speed = 250
var has_egg : bool = false

var score = 0
var vel : Vector2 = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	vel.x = 0
	vel.y = 0
	if Input.is_action_pressed("move_up"):
		vel.y = -speed
	if Input.is_action_pressed("move_down"):
		vel.y = speed
	if Input.is_action_pressed("move_left"):
		vel.x = -speed
	if Input.is_action_pressed("move_right"):
		vel.x = speed

	move_and_slide(vel, Vector2.UP)

		
func pick_up_egg():
	has_egg = true
	speed = 100
	
func drop_of_egg():
	has_egg = false
	score += 1
	speed = 250
