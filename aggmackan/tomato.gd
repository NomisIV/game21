extends Area2D

var speed = 400
var vel = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	position += transform.x * speed * delta
	get_node("Sprite").rotate(PI/12)
	for body in get_overlapping_bodies():
		if body.has_method("hit_by_tomato"):
			body.hit_by_tomato()
		if !body.has_method("throw_tomato"):
			queue_free()

func _on_Bullet_body_entered(body):
	if body.has_method("hit_by_tomato"):
		body.hit_by_tomato()
	if !body.has_method("throw_tomato"):
		queue_free()
