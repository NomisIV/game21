extends KinematicBody2D

var score : int = 0

var maxJumps = 1
var extraJumps = maxJumps
var speed : int = 100
var maxSpeed = 800
var floorspeed = 150
var floormaxSpeed = 500 
var jumpForce : int = 900
var gravity : int = 1800
var dashing = 0
var dashTime = 10
var dashSpeed = 1000
var friction = 30
var floorFriction = 50

var vel : Vector2 = Vector2()
onready var animatedSprite = get_node("AnimatedSprite")

# Movement
func _physics_process(delta):
	if Input.is_action_just_pressed("Dash"):
		dashing = dashTime
		if Input.is_action_pressed("move_right"):
			vel.x = dashSpeed
			vel.y = 0
		elif Input.is_action_pressed("jump"):
			vel.y = -dashSpeed
			vel.x = 0
		elif Input.is_action_pressed("down"):
			vel.y = dashSpeed
			vel.x = 0
		else:
			vel.x = -dashSpeed
			vel.y = 0
	if dashing != 0:
		dashing -= 1
			
	else:	
		if is_on_floor():
			extraJumps = maxJumps
		
		if Input.is_action_pressed("move_left"):
			if is_on_floor():
				vel.x -= floorspeed
			else:
				vel.x -= speed
		if Input.is_action_pressed("move_right"):
			if is_on_floor():
				vel.x += floorspeed
			else:
				vel.x += speed
		if Input.is_action_just_pressed("jump") and (is_on_floor() || extraJumps != 0):
			if (!is_on_floor() and !is_on_wall()):
				vel.y = 0
				extraJumps -= 1
			if is_on_wall():
				if Input.is_action_pressed("move_left"):
					vel.x += jumpForce
				else:
					vel.x -= jumpForce
			vel.y -= jumpForce

		if vel.x < friction:
			vel.x += friction
		if vel.x > friction:
			vel.x -= friction
		if vel.x < friction*2 and vel.x > -friction*2:
			vel.x = 0
		if is_on_floor():
			if vel.x < -floormaxSpeed:
				vel.x = -floormaxSpeed
			if vel.x > floormaxSpeed:
				vel.x = floormaxSpeed
			if vel.x < floorFriction:
				vel.x += floorFriction
			if vel.x > floorFriction:
				vel.x -= floorFriction
			if vel.x < floorFriction+1 and vel.x > -floorFriction-1:
				vel.x = 0
		else:
			if vel.x < friction:
				vel.x += friction
			if vel.x > friction:
				vel.x -= friction
			if vel.x < friction+1 and vel.x > -friction-1:
				vel.x = 0
			if vel.x < -maxSpeed:
				vel.x = -maxSpeed
			if vel.x > maxSpeed:
				vel.x = maxSpeed
		if is_on_wall() and (Input.is_action_pressed("move_left") or 
			Input.is_action_pressed("move_right")) and not (
			Input.is_action_just_pressed("jump")):
			vel.y = 0
		else:
			vel.y += gravity * delta
	vel = move_and_slide(vel, Vector2.UP)
	if vel.x == 0:
			animatedSprite.play("idel")
	else:
		animatedSprite.play("run")
		if vel.x < 0:
			animatedSprite.set_flip_h(true)
		else:
			animatedSprite.set_flip_h(false)

