extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var root = null
var player = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	player = get_tree().get_root().get_node("Root").get_node("player")	
	pass


func _on_enemy_body_enter( body ):
	if body.get_name() != "TileMap":
		player._on_contact_with_spiked_enemy()
