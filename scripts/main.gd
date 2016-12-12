extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	global.start_time = OS.get_unix_time()
	set_process(true)
	pass

func _process(delta):
	if global.lives <= 0:
		print("out of lives")
		get_tree().change_scene("res://scenes/ouch.tscn")
		self.queue_free()

func _on_Area2D_body_enter_pendulum( body ):
	print(body.get_name())
	
func _player_has_reached_exit():
	global.end_time = OS.get_unix_time()
	print("exit reached")
	get_tree().change_scene("res://scenes/end.tscn")
	self.queue_free()
	