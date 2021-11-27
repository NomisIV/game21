extends KinematicBody2D
const MAX_SHOTS = 5
const FIRE_RATE_TIME = 1
const BURST_RATE_TIME = 0.1
const SPEED = 150
const TURN_AMOUNT = PI/2
const HUNT_COOLDOWN = 8
const DISTANCE_TO_BE_HOME = 100
const Fireball = preload("res://fireball.tscn")
var rng = RandomNumberGenerator.new()
onready var player = get_parent().get_node("Player")
onready var tileMap = get_parent().get_node("Map").get_child(0)
var test = true
var vel = Vector2(1, 0)
var previous_vel = Vector2(1, 0)
var hunting_timer = 0
var is_searching = false
var shake_timer = 0
var found_last_seen = false
onready var last_seen = player.global_position

var doing_burst = false
var shots_in_burst = MAX_SHOTS
var fire_rate = FIRE_RATE_TIME
var burst_rate = BURST_RATE_TIME


	
func _physics_process(delta):
	if shake_timer <= 0:
		var space_state = get_world_2d().direct_space_state
		var is_player_in_vision = space_state.intersect_ray(self.global_position, player.global_position, [self, player])
		if !is_player_in_vision:
			hunting_timer = HUNT_COOLDOWN
			last_seen = player.global_position
			do_burst(delta, last_seen)
			walk_towards(last_seen)
			found_last_seen = false
		else:
			var number = self.get_name()[-1]
			var nest_position = get_parent().get_node("nest" + number).global_position
			if hunting_timer > 0:
				if global_position.distance_to(last_seen) > DISTANCE_TO_BE_HOME/8 and !found_last_seen:
					do_burst(delta, last_seen)
					walk_towards(last_seen)
				else:
					found_last_seen = true
					do_burst(delta, player.global_position)
					walk_towards(player.global_position)
				hunting_timer -= delta
				is_searching = true
			elif is_searching:
				is_searching = false
				shake_timer = 2
			elif self.global_position.distance_to(nest_position) > DISTANCE_TO_BE_HOME:
				walk_towards(nest_position)
				
	else:
		shake(delta)

func shake(delta):
	shake_timer -= delta
	vel = Vector2(rng.randf_range(-200, 200), rng.randf_range(-200, 200))
	move_and_slide(vel, Vector2.UP)
	
func do_burst(delta, target):
	if doing_burst or fire_rate > FIRE_RATE_TIME:
		if !doing_burst:
			shots_in_burst = MAX_SHOTS
			doing_burst = true
		if shots_in_burst > 0 and burst_rate > BURST_RATE_TIME:
			shoot_fire_towards(target)
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
	var spread = rng.randf_range(-PI/8, PI/8)
	var fireball = Fireball.instance()
	get_parent().add_child(fireball)
	fireball.transform = global_transform
	fireball.look_at(target)
	fireball.rotate(spread)

func walk_towards(target):
	vel = global_position.direction_to(target).normalized()
	$rays.rotation = vel.angle() + 3*PI/2
	var space_state = get_world_2d().direct_space_state
	#var raycast_u_result = space_state.intersect_ray(self.global_position, $rays/up_point.global_position, [self, player])
	var raycast_l_result = space_state.intersect_ray(self.global_position, $rays/left_point.global_position, [self, player])
	var raycast_r_result = space_state.intersect_ray(self.global_position, $rays/right_point.global_position, [self, player])
	var raycast_d_result = space_state.intersect_ray(self.global_position, $rays/down_point.global_position, [self, player])
	#var raycast_ul_result = space_state.intersect_ray(self.global_position, $rays/up_l_point.global_position, [self, player])
	#var raycast_ur_result = space_state.intersect_ray(self.global_position, $rays/up_r_point.global_position, [self, player])
	var raycast_dl_result = space_state.intersect_ray(self.global_position, $rays/down_l_point.global_position, [self, player])
	var raycast_dr_result = space_state.intersect_ray(self.global_position, $rays/down_r_point.global_position, [self, player])

	if raycast_d_result:
		vel += vel.rotated(TURN_AMOUNT)
	elif raycast_l_result:
		vel += vel.rotated(-TURN_AMOUNT)
	elif raycast_r_result:
		vel += vel.rotated(TURN_AMOUNT)
	elif raycast_dl_result:
		vel += vel.rotated(-TURN_AMOUNT/2)
	elif raycast_dr_result:
		vel += vel.rotated(TURN_AMOUNT/2)
		
	previous_vel = vel
	
	vel.x *= SPEED
	vel.y *= SPEED
	vel = vel.clamped(SPEED)
	move_and_slide(vel, Vector2.UP)
