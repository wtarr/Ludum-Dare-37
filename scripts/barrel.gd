extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var angular_velocity = 100
export var linear_velocity = Vector2(50, 0)

var player = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	#set_fixed_process(true)
	player = get_tree().get_root().get_node("Root").get_node("player")	
	set_angular_velocity(angular_velocity)
	set_linear_velocity(linear_velocity)
	set_gravity_scale(2)
	pass

func _on_Area2D_body_enter( body ):	
	var name = body.get_name()
	
	var matchTileMap = name.find("TileMap", 0)
	var matchPlayer = name.find("player", 0)
	
	if (matchTileMap > -1 or matchPlayer > -1):
		#get_node("Sprite").set_opacity(0) # make it disapper
		get_node("AnimationPlayer").play("explode")
	if (matchPlayer > -1):
		player._on_contact_with_barrel()
	
	
	#pass # replace with function body
func anim_expired():
	queue_free()
	