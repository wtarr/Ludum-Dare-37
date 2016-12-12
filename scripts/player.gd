extends KinematicBody2D

var tileMap = null

var gravity = 200.0

var floor_angle_tolerence = 40 # within + or - of this constitutes being on the floor
var walk_force = 90
var walk_min_speed = 0.5
var walk_max_speed = 5
var stop_force = 150
var jump_speed = 25

var jump_max_airborne_time = 0.2

var slide_stop_velocity = 1.0
var slide_stop_min_travel = 1.0

var velocity = Vector2()
var on_air_time = 100
var jumping = false

var prev_jump_pressed = false

var latest_spawn_point = null
var lives = 10
var revert_to_last_checkpoint = false
#var slashAnim = preload("res://../scenes/slash.tscn")
#var slashAnimInstance

func _fixed_process(delta):
	get_node("Label").set_text("Lives: " + str(lives))
	
	if revert_to_last_checkpoint:
		revert_to_last_checkpoint = false
		deduct_life()
		#revert_motion()
		#move_to(latest_spawn_point)
		set_pos(latest_spawn_point)
		return
	
	var force = Vector2(0, gravity)
	
	var walk_left = Input.is_action_pressed("move_left")
	var walk_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	var slash = Input.is_action_pressed("slash")
	
	# reset the stop flag on every loop
	var stop = true
	
	# if walking left or right, check that velocity limit has not been exceeded
	if (walk_right):
		if (velocity.x >= -walk_min_speed and velocity.x < walk_max_speed):
			force.x += walk_force
			stop = false
	elif (walk_left):
		if (velocity.x <= walk_min_speed and velocity.x > -walk_max_speed):
			force.x -= walk_force
			stop = false
			
	#if (slash):
	#	get_node("slash").get_node("AnimationPlayer").play("slash")
	
	if (stop):
		var vsign = sign(velocity.x) # - or + ?
		var vlen = abs(velocity.x) # magnitude
		
		vlen -= stop_force*delta # calculate a negative force to kill the x velocity
		
		if (vlen < 0): # cant go any slower than 0
			vlen = 0

		velocity.x = vlen*vsign # apply the force to this velocity calculation
	
	# apply external forces (gravity, wind)
	velocity += force*delta
	
	var motion = velocity*delta
	
	motion = move(velocity)

	var floor_velocity = Vector2()
		
	if (is_colliding()):
		# You can check which tile was collision against with this
		#var meta = get_collider_metadata()	
		
		var collider = get_collider()
		
		var collider_meta = get_collider_metadata()
		
		var collider_pos = collider.get_pos()
		
		var collider_name = collider.get_name()
		
		#if collider == "TileMap":
  		#	var pos = body.world_to_map(get_pos())
  		#	var id = body.get_cell(pos.x,pos.y)
  		#	var body_name = body.get_tileset().tile_get_name(id)
		
		if collider_name == "TileMap":
			var tile = tileMap.get_cellv(get_collider_metadata())
			if tile == 1:
				_on_contact_with_spiked_tile()
		
		#if collider_name != "TileMap":
		#	print("hit by " + collider_name + " - todo logic here")
		
		# Ran against something, is it the floor? Get normal
		var n = get_collision_normal()
		
		if (rad2deg(acos(n.dot(Vector2(0, -1)))) < floor_angle_tolerence):
			# If angle to the "up" vectors is < angle tolerance
			# char is on floor
			on_air_time = 0
			floor_velocity = get_collider_velocity()
			jumping = false # does this fix it?
		
		if (on_air_time == 0 and force.x == 0 and get_travel().length() < slide_stop_min_travel and abs(velocity.x) < slide_stop_velocity and get_collider_velocity() == Vector2()):
			revert_motion()
			velocity.y = 0.0
		else:
			motion = n.slide(motion)
			velocity = n.slide(velocity)
			# Then move again
			move(motion)
	
	if (floor_velocity != Vector2()):
		# If floor moves, move with floor
		move(floor_velocity*delta)

	# stops player double jumping
	if (jumping and velocity.y > 0):
		jumping = false
	
	if (on_air_time < jump_max_airborne_time and jump and not prev_jump_pressed and not jumping):
		velocity.y =- jump_speed
		jumping = true
	
	on_air_time += delta
	prev_jump_pressed = jump

func _ready():
	#slashAnimInstance = slashAnim.instance()
	#add_child(slashAnimInstance)
	latest_spawn_point = get_pos()
	tileMap = get_tree().get_root().get_node("Root").get_node("TileMap")
	set_fixed_process(true)

func _on_contact_with_spiked_enemy():
	print("hit by an enemy - take action")
	set_revert_to_checkpoint()
	
func _on_contact_with_barrel():
	print("hit by barrel - take action - func")
	set_revert_to_checkpoint()
	
func _on_contact_with_spiked_tile():
	print("spike contact - action needed")
	set_revert_to_checkpoint()

func _on_pendulum_collision():
	print("pendulum contact - action needed")
	set_revert_to_checkpoint()

func _on_contact_with_checkpoint(spawn_pt):
	print("checkpoint reached")
	latest_spawn_point = spawn_pt

func set_revert_to_checkpoint():
	revert_to_last_checkpoint = true

func deduct_life():
	lives -= 1