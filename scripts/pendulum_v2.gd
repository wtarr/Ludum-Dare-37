extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var player = null

func _ready():
	player = get_tree().get_root().get_node("Root").get_node("player")
	pass

func _on_Area2D_body_enter( body ):
	var name = body.get_name()
	var matchPlayer = name.find("player", 0)
	
	if (matchPlayer > -1):
		player._on_pendulum_collision()
