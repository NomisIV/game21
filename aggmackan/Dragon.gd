extends KinematicBody2D
const MAX_SHOTS = 5
const FIRE_RATE_TIME = 1
const BURST_RATE_TIME = 0.1
const SPEED = 100
const TURN_AMOUNT = PI/2
const HUNT_COOLDOWN = 5
const Fireball = preload("res://fireball.tscn")
onready var player = get_parent().get_node("Player")
onready var tileMap = get_parent().get_node("Map").get_child(0)
var test = true
var vel = Vector2(1, 0)
var hunting_timer = 0

var doing_burst = false
var shots_in_burst = MAX_SHOTS
var fire_rate = FIRE_RATE_TIME
var burst_rate = BURST_RATE_TIME


	
func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	var is_player_in_vision = space_state.intersect_ray(self.global_position, player.global_position, [self, player])
	if !is_player_in_vision:
		hunting_timer = HUNT_COOLDOWN
		do_burst(delta)
		walk_towards(player.global_position)
	else:
		if hunting_timer > 0:
			do_burst(delta)
			walk_towards(player.global_position)
			hunting_timer -= delta


func do_burst(delta):
	if doing_burst or fire_rate > FIRE_RATE_TIME:
		if !doing_burst:
			shots_in_burst = MAX_SHOTS
			doing_burst = true
		if shots_in_burst > 0 and burst_rate > BURST_RATE_TIME:
			shoot_fire_towards(get_parent().get_node("Player").global_position)
			shots_in_burst -= 1
			burst_rate = 0
		else:
			burst_rate += delta
		if shots_in_burst <= 0:
			doing_burst = false
			fire_rate = 0
	else:
		fire_rate += delta
		
		
func shoot_fire_towards(target):
	var fireball = Fireball.instance()
	get_parent().add_child(fireball)
	fireball.transform = global_transform
	fireball.look_at(target)

func walk_towards(target):
	vel = global_position.direction_to(target)
	$rays.rotation = vel.angle() + 3*PI/2
	var space_state = get_world_2d().direct_space_state
	var raycast_m_result = space_state.intersect_ray(self.global_position, $rays/middle_point.global_position, [self, player])
	var raycast_l_result = space_state.intersect_ray(self.global_position, $rays/left_point.global_position, [self, player])
	var raycast_r_result = space_state.intersect_ray(self.global_position, $rays/right_point.global_position, [self, player])
	
	if raycast_m_result or raycast_l_result:
		vel = vel.rotated(TURN_AMOUNT)
	elif raycast_r_result:
		vel = vel.rotated(-TURN_AMOUNT)
	
	vel.x *= SPEED
	vel.y *= SPEED
	move_and_slide(vel, Vector2.UP)
