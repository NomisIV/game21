extends Node2D


var angry_dragons = 0
onready var ambient = get_parent().get_node("ambientmusic")
onready var run = get_parent().get_node("runmusic")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if angry_dragons <= 0 and !ambient.playing:
		ambient.play()
		run.stop()
	elif angry_dragons > 0 and !run.playing:
		ambient.stop()
		run.play()

func play_run():
	angry_dragons += 1

func stop_run():
	angry_dragons -= 1
