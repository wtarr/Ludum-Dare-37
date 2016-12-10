extends KinematicBody2D

var gravity = 200.0

var floor_angle_tolerence = 40 # within + or - of this constitutes being on the floor
var walk_force = 90
var walk_min_speed = 0.5
var walk_max_speed = 5
var stop_force = 200
var jump_speed = 25

var jump_max_airborne_time = 0.2

var slide_stop_velocity = 1.0
var slide_stop_min_travel = 1.0

var velocity = Vector2()
var on_air_time = 100
var jumping = false

var prev_jump_pressed = false

var slashAnim = preload("res://../scenes/slash.tscn")
var slashAnimInstance

var pendulum_class = preload("res://../scripts/pendulum_v2.gd")

func _fixed_process(delta):
	
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
			
	if (slash):
		get_node("slash").get_node("AnimationPlayer").play("slash")
	
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
			# For every other case of motion, our motion was interrupted.
			# Try to complete the motion by "sliding" by the normal
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
	set_fixed_process(true)


func _on_custom_collision_area_enter( area ):
	pass # replace with function body
