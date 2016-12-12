extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var player = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	player = get_tree().get_root().get_node("Root").get_node("player")
	pass


func _on_checkpoint_body_enter( body ):
	var spawn = get_node("spawn_point").get_global_pos()
	player._on_contact_with_checkpoint(spawn)
	pass # replace with function body
