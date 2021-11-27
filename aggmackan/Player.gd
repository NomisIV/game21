extends KinematicBody2D

const NORMAL_SPEED = 150
const EGG_SPEED = 100
var speed = NORMAL_SPEED
var has_egg : bool = false
var dodge_speed = 400
var dodge_time = 0.2

var score = 0
var vel : Vector2 = Vector2()
var dodge_vel = Vector2()
onready var dodge_timer = get_node("Timer")
onready var sprite = get_node("AnimatedSprite")
onready var dodge_emmiter = get_node("dodge_par")


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

	if Input.is_action_just_released("dodge"):
		dodge_emmiter.rotation_degrees = 0
		dodge_emmiter.rotate(vel.angle()+PI/2)
		dodge_timer.start(dodge_time)
		vel = vel.normalized()*dodge_speed
		dodge_vel = vel
		
	
	if dodge_timer.time_left != 0:
		vel = dodge_vel
		dodge_emmiter.emitting = true
	else:
		dodge_emmiter.emitting = false
		dodge_vel = Vector2()
		
	if vel.length() > 0:
		sprite.playing = true
	else:
		sprite.playing = false
		sprite.frame = 0
	
	if vel.x > 0:
		sprite.flip_h = false
	elif vel.x < 0:
		sprite.flip_h = true

		
	move_and_slide(vel, Vector2.UP)

		
func pick_up_egg():
	has_egg = true
	speed = EGG_SPEED
	
func drop_of_egg():
	has_egg = false
	score += 1
	speed = NORMAL_SPEED
