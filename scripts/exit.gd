extends Area2D

var root = null

func _ready():
	root = get_tree().get_root().get_node("Root")
	pass


func _on_exit_body_enter( body ):
	root._player_has_reached_exit()
	pass # replace with function body
