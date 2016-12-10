extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_Area2D_body_enter_pendulum( body ):
	print(body.get_name())

func _on_Area2D_body_enter_barrel( body ):
	print("barrel " + body.get_name())
