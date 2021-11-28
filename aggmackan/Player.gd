extends KinematicBody2D

enum Items {
	NONE,
	EGG,
	CAVIAR,
}

const NORMAL_SPEED = 170
const EGG_SPEED = 100
const MAX_HP = 8
var speed = NORMAL_SPEED
var has_egg : bool = false
var dodge_speed = 400
var dodge_time = 0.2
var hp = MAX_HP
const DODGE_SPEED = 400
const DODGE_TIME = 0.2
const CAVIAR_SQUIRTS = 5
var equipped_item = Items.NONE
var remaining_caviar = 0

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

	if Input.is_action_just_released("dodge") and equipped_item == Items.CAVIAR:
		dodge_emmiter.rotation_degrees = 0
		dodge_emmiter.rotate(vel.angle()+PI/2)
		dodge_timer.start(DODGE_TIME)
		remaining_caviar -= 1
		if remaining_caviar == 0:
			equipped_item = Items.NONE
		vel = vel.normalized()*DODGE_SPEED
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

	if dodge_timer.time_left <= 0:
		vel = vel.clamped(NORMAL_SPEED)
	sprite.speed_scale = vel.length()*0.013
	move_and_slide(vel, Vector2.UP)

		
func pick_up_egg():
	equipped_item = Items.EGG
	speed = EGG_SPEED

func drop_of_egg():
	if(equipped_item == Items.EGG):
		equipped_item = Items.NONE
		score += 1
		hp = MAX_HP
		speed = NORMAL_SPEED

func hit_by_fireball():
	hp -= 1
	if hp <= 0:
		global_position = get_parent().get_node("campfire").global_position
		equipped_item = Items.NONE
		speed = NORMAL_SPEED
		hp = MAX_HP
		print(score)
		score = 0
		
	
func pick_up_caviar():
	equipped_item = Items.CAVIAR
	remaining_caviar = CAVIAR_SQUIRTS
