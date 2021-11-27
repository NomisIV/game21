extends Area2D

var speed = 400
var vel = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.x * speed * delta
	for body in get_overlapping_bodies():
		if body.has_method("hit_by_fireball"):
			body.hit_by_fireball()
		if !body.has_method("shoot_fire_towards"):
			queue_free()

func _on_Bullet_body_entered(body):
	if body.has_method("hit_by_fireball"):
		body.hit_by_fireball()	
	if !body.has_method("shoot_fire_towards"):
		queue_free()
