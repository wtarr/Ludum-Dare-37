extends Position2D

var barrel = preload("res://../scenes/barrel.tscn")

export var scale = 1
export var angular_velocity = 100
export var linear_velocity = Vector2(50, 0)

func _ready():
	get_node("Sprite").set_scale(Vector2(scale, scale))
	pass

func launch():
	var inst = barrel.instance()
	inst.angular_velocity = angular_velocity
	inst.linear_velocity = linear_velocity
	inst.set_pos(get_parent().get_pos())
	add_child(inst)
	
