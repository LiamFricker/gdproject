extends CharacterBody2D
## This character controller was created with the intent of being a decent starting point for Platformers.
## 
## Instead of teaching the basics, I tried to implement more advanced considerations.
## That's why I call it 'Movement 2'. This is a sequel to learning demos of similar a kind.
## Beyond coyote time and a jump buffer I go through all the things listed in the following video:
## https://www.youtube.com/watch?v=2S3g8CgBG1g
## Except for separate air and ground acceleration, as I don't think it's necessary.


# BASIC MOVEMENT VARAIABLES ---------------- #
var face_direction := 1
var facing_direction := 1
var kicking_direction := 1
var x_dir := 1
var movement_enabled := true
var testnum := 0
var slidingbug := true
var slidingdirection := 1

@export var max_speed: float = 560
@export var acceleration: float = 2880
@export var turning_acceleration : float = 9600
@export var friction: float = 20
# ------------------------------------------ #

# GRAVITY ----- #
@export var gravity_acceleration : float = 3840
@export var gravity_max : float = (1020)
var gravity_enabled := true
# ------------- #

# DASH VARAIABLES ------------------- #
@export var dash_length : float = 3840
@export var dash_speed : float = 1000
var dash_timer : float = 0
@export var dash_cool : float = 0.8
var dash_cooldown : float = 0
@export var dashes_remaining : float = 1
# ------------------------------------------ #

# CHARGE DASH VARAIABLES ------------------- #
@export var charge_dash : bool = true
@export var charge_x_mult : float = 1
@export var charge_y_mult : float = 1
@export var charge_time : float = 1.5
var charge_timer : float = 0
@export var charge_delay : float = 0.5
var chargedelay_timer : float = 0
var chargedash_length : float = dash_length
var chargedash_speed : float = dash_speed
#@export var charging_buffer : float = 0.2
var charging_buffer_timer : bool = false #float = 0.1
# ------------------------------------------ #

# KICK VARAIABLES ------------------- #
@export var kick_speed : float = 1.25
@export var kick_length : float = 0.25
var kick_timer : float = 0
@export var kick_cool : float = 0.25
var kick_cooldown : float = 0
var slidekick : bool = false
# ------------------------------------------ #

# COMET KICK VARAIABLES ------------------- #
@export var comet_kick_mult : float = 0.75
var kicking : bool = false
# ------------------------------------------ #

# JUMP VARAIABLES ------------------- #
@export var jump_force : float = 1400
@export var jump_cut : float = 1.5
@export var jump_gravity_max : float = 500
@export var jump_hang_treshold : float = 2.0
@export var jump_hang_gravity_mult : float = 0.1
# ----------------------------------- #

# WALL JUMP VARIABLES ------------------- #
@export var wall_jump : bool = true
@export var wall_friction : float = 0.20
@export var walljump_mult : float = 0.75
@export var wallkick_mult : float = 0.25
@export var walljump_push : float = 800
@export var wallkick_push : float = 2000
var wallmove_timer : float = 0
@export var wallmove_cooldown : float = 0.25
# ----------------------------------- #

# DOWN AIR VARIABLES ------------------- #
@export var down_air : bool = true
@export var downair_delay : float = 0.20
var downair_timer : float = 0
@export var downair_cool : float = 1
var downair_cooldown : float = 0
@export var downair_mult : float = 1.75
@export var downair_x : float = 0.25
var lock_abilities : bool = false
var downairing : bool = false
# ----------------------------------- #

# SLIDING VARIABLES ------------------- #
@export var sliding_mult : float = 2
var sliding : bool = false
# ----------------------------------- #

# Timers
@export var jump_coyote : float = 0.08
@export var jump_buffer : float = 0.1
@export var dash_buffer : float = 0.1
@export var walljump_coyote : float = 0.08
@export var slide_buffer : float = 0.05
var jump_coyote_timer : float = 0
var jump_buffer_timer : float = 0
var dash_buffer_timer : float = 0
var walljump_coyote_timer : float = 0
var is_jumping := false
var slide_buffer_timer : float = 0
# ----------------------------------- #
var collider : KinematicCollision2D

# All iputs we want to keep track of
func get_input() -> Dictionary:
	return {
		"x": int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")),
		"down": int(Input.is_action_just_pressed("down")),# - int(Input.is_action_pressed("ui_up")),
		"just_jump": Input.is_action_just_pressed("jump") == true,
		"jump": Input.is_action_pressed("jump") == true,
		"released_jump": Input.is_action_just_released("jump") == true,
		"attack": Input.is_action_just_pressed("attack") == true
	}


func _physics_process(delta: float) -> void:
	if(not lock_abilities):	
		dash_logic(delta)
	x_movement(delta)
	jump_logic(delta)
	apply_gravity(delta)
	if (raycast_on_wall() and gravity_enabled and velocity.y >= 0 and not lock_abilities and wall_jump): #or walljump_coyote_timer > 0:
		walljump_logic(delta)
	if (get_input()["down"] or downairing) and gravity_enabled and down_air:	
		downair_logic(delta)
	if(gravity_enabled and slidekick):	
		kick_logic(delta)
	timers(delta)
	move_and_slide()
	
	
	#print(facing_direction)
func dash_logic(_delta: float) -> void:

	if is_on_floor_only():
		dashes_remaining = 1
	if charge_dash:
		if Input.is_action_just_pressed("dash") and dash_buffer_timer < 0:
			chargedelay_timer = charge_delay
			charge_timer = charge_time# + charge_delay 
		if Input.is_action_pressed("dash"):
			if chargedelay_timer < 0: #and dash_cooldown <= 0:	
				chargedash_length = dash_length * (2.5-(charge_timer*(1.5/(charge_time - charge_delay)))) 
				chargedash_speed = dash_speed * (1.75-(charge_timer*0.5*(1.5/(charge_time - charge_delay))))
		if Input.is_action_just_released("dash") and sliding == false:
			dash_buffer_timer = dash_buffer	
		if dash_buffer_timer > 0 and dash_timer <= 0 and (dash_cooldown <= 0) and dashes_remaining == 1:
			#print("true")
			facing_direction = face_direction
			dash_timer = chargedash_length/chargedash_speed
			dash_cooldown = dash_cool
			dashes_remaining = 0
			movement_enabled = false
			gravity_enabled = false
			charging_buffer_timer = true
			if is_on_floor():	
				velocity.x = (chargedash_speed * facing_direction) + (max_speed * 0.15)
				return
			velocity.x = (chargedash_speed * facing_direction)
			
		elif (dash_timer) > 0:
			dash_timer -= 0.4
			if (dash_timer) <= 0:
				velocity.x *= 0.2
				movement_enabled = true
				gravity_enabled = true
				chargedash_length = dash_length
				chargedash_speed = dash_speed
				charging_buffer_timer = false
				return
			if is_on_floor():	
				velocity.x = (chargedash_speed * facing_direction) + (max_speed * 0.15)
				dash_cooldown = dash_cool * 1.5
				return
			velocity.x = (chargedash_speed * facing_direction)
	else:
		if Input.is_action_just_pressed("dash"):
			dash_buffer_timer = dash_buffer	
		if dash_buffer_timer > 0 and dash_timer <= 0 and (dash_cooldown <= 0) and dashes_remaining == 1:
			#print("true")
			facing_direction = face_direction
			dash_timer = dash_length/dash_speed
			dash_cooldown = dash_cool
			dashes_remaining = 0
			movement_enabled = false
			gravity_enabled = false
			if is_on_floor():	
				velocity.x = (dash_speed * facing_direction) + (max_speed * 0.35)
				dash_cooldown = dash_cool * 1.2
				return
			velocity.x = (dash_speed * facing_direction)
			
		elif (dash_timer) > 0:
			dash_timer -= 0.4
			if (dash_timer) <= 0:
				velocity.x *= 0.2
				movement_enabled = true
				gravity_enabled = true
				return
			if is_on_floor():	
				velocity.x = (dash_speed * facing_direction) + (max_speed * 0.35)
				return
			velocity.x = (dash_speed * facing_direction)

func x_movement(delta: float) -> void:
	#if dash_timer > 0:
	#	velocity.x = (dash_speed*(sign(velocity.x)))
	#	return
	if (not movement_enabled and wallmove_timer >= 0):
		x_dir = 0
	elif sliding:
		if abs(velocity.x) >= 500:
			return
		x_dir = get_input()["x"]
		lock_abilities = false
		sliding = false
	else:
		x_dir = get_input()["x"] 
	set_direction(x_dir) # This is purely for visuals
	
	if is_on_floor():
	# Stop if we're not doing movement inputs.
		if x_dir == 0: 
			velocity.x *= 1 / (1 + (delta * 20))
			return
		
		# If we are doing movement inputs and above max speed, don't accelerate nor decelerate
		# Except if we are turning
		# (This keeps our momentum gained from outside or slopes)
		if abs(velocity.x) >= (max_speed-20) and sign(velocity.x) == x_dir:
			return
		
		# Are we turning?
		# Deciding between acceleration and turn_acceleration
		var accel_rate : float = acceleration if sign(velocity.x) == x_dir else (turning_acceleration * (0.5/(1+delta)))
		
		# Accelerate
		velocity.x += x_dir * accel_rate * delta
		
	
	else:
		# If we are doing movement inputs and above max speed, don't accelerate nor decelerate
		# Except if we are turning
		# (This keeps our momentum gained from outside or slopes)
		if x_dir == 0: 
			velocity.x *= 1 / (1 + (delta * 4))
			return
		if abs(velocity.x) >= (max_speed-20) and sign(velocity.x) == x_dir:
			return
		
		# Are we turning?
		# Deciding between acceleration and turn_acceleration
		var accel_rate : float = acceleration if sign(velocity.x) == x_dir else (turning_acceleration * (1+(1/(1+delta))))
		
		# Accelerate
		velocity.x += x_dir * accel_rate * delta * 0.5
		#velocity.x *= 0.95

	



func set_direction(hor_direction) -> void:
	# This is purely for visuals
	# Turning relies on the scale of the player
	# To animate, only scale the sprite
	if hor_direction == 0:
		return
	apply_scale(Vector2(hor_direction * face_direction, 1)) # flip
	face_direction = hor_direction # remember direction


func jump_logic(_delta: float) -> void:
	# Reset our jump requirements

	if is_on_floor(): 
		jump_coyote_timer = jump_coyote
		is_jumping = false
	if (jump_coyote_timer) > 0:
		is_jumping = false
	if get_input()["just_jump"]:
		jump_buffer_timer = jump_buffer
	# Jump if grounded, there is jump input, and we aren't jumping already
	if jump_coyote_timer > 0 and jump_buffer_timer > 0 and not is_jumping:
		is_jumping = true
		jump_coyote_timer = 0
		jump_buffer_timer = 0
		# If falling, account for that lost speed
		if velocity.y > 0:
			velocity.y -= velocity.y
			
		
		velocity.y = -jump_force
	# We're not actually interested in checking if the player is holding the jump button
#	if get_input()["jump"]:pass
	
	# Cut the velocity if let go of jump. This means our jumpheight is varaiable
	# This should only happen when moving upwards, as doing this while falling would lead to
	# The ability to studder our player mid falling

	if get_input()["released_jump"] and velocity.y < -400:
		velocity.y -= (jump_cut * velocity.y)
	
	# This way we won't start slowly descending / floating once hit a ceiling
	# The value added to the treshold is arbritary,
	# But it solves a problem where jumping into 
	if is_on_ceiling(): velocity.y = jump_hang_treshold + 100.0

func apply_gravity(delta: float) -> void:
	var applied_gravity : float = 0
	
	# No gravity if we are grounded
	#if jump_coyote_timer > 0:
	#	return
	if (not gravity_enabled):
		velocity.y = 0
		return
	# Normal gravity limit
	#if is_on_wall_only() and not is_on_floor(): 
	#	if velocity.y <= gravity_max * wall_friction:
	#		applied_gravity = gravity_acceleration * delta * wall_friction
	#else:
	if velocity.y <= (gravity_max):
		applied_gravity = gravity_acceleration * delta
	# If moving upwards while jumping, the limit is jump_gravity_max to achieve lower gravity
	if (is_jumping and velocity.y < 0) and velocity.y > jump_gravity_max:
		applied_gravity = 0
	
	# Lower the gravity at the peak of our jump (where velocity is the smallest)
	if is_jumping and abs(velocity.y) < jump_hang_treshold:
		applied_gravity *= jump_hang_gravity_mult

	
	
	
	velocity.y += applied_gravity

func walljump_logic(_delta: float) -> void:
	# Reset our jump requirements
	if is_on_wall_only():	
		walljump_coyote_timer = walljump_coyote	
	if velocity.y >= (gravity_max * wall_friction) and walljump_coyote_timer == walljump_coyote: #and walljump_coyote_timer >= (walljump_coyote_timer * 0.9):	
		velocity.y = gravity_max * wall_friction
	if get_input()["attack"] and (-(get_input()["x"]) == sign(get_wall_normal().x)):
		is_jumping = true
		jump_buffer_timer = 0
		walljump_coyote_timer = 0
		if velocity.y > 0:
			velocity.y -= velocity.y
		velocity.x += (wallkick_push * sign(get_wall_normal().x))
		velocity.y = -(jump_force * 0.5)
		movement_enabled = false
		wallmove_timer = wallmove_cooldown
	if jump_buffer_timer > 0:# 
		is_jumping = true
		jump_buffer_timer = 0
		walljump_coyote_timer = 0
		# If falling, account for that lost speed
		if velocity.y > 0:
			velocity.y -= velocity.y
		if is_on_wall():
			velocity.x += (walljump_push * sign(get_wall_normal().x))
		else:
			print("true")
			velocity.x += (walljump_push * sign(get_raycast_normal().x))
		velocity.y = -(jump_force * 0.85)
		movement_enabled = false
		wallmove_timer = wallmove_cooldown
	
func _on_bouncer_bounce():
	#check if down airing
	if  (downairing and downair_timer < 0) or (slide_buffer_timer > 0):		
		is_jumping = true
		jump_buffer_timer = 0
		velocity.y = -(jump_force*1.5)
		downairing = false
		lock_abilities = false
		downair_timer = downair_delay
		downair_cooldown = 0


func _on_brick_brickbreak(extra_arg_0):
	if  (downairing and downair_timer < 0) or (slide_buffer_timer > 0):
		print("true")
		var brick = get_node(extra_arg_0)
		brick.destroy()

func _on_block_blockbreak(extra_arg_0):
	if (charging_buffer_timer):
		print("true")
		var block = get_node(extra_arg_0)
		block.destroy()

func _on_slope_left_slope_l():
	if  (downairing and downair_timer < 0) or (slide_buffer_timer > 0):		
		velocity.x = (max_speed*1.5)
		downairing = false
		#lock_abilities = false
		sliding = true
		downair_timer = downair_delay
		downair_cooldown = 0
	if (charging_buffer_timer):
		is_jumping = true
		jump_buffer_timer = 0
		velocity.y = -(jump_force*1.5)
		velocity.x *= 0.2
		#movement_enabled = true
		lock_abilities = false
		gravity_enabled = true
		charging_buffer_timer = false
		dashes_remaining = 1
		dash_timer = 0.3
		dash_cooldown = dash_cool * 0.7
	#else:
	#	if  (downairing or slide_buffer_timer > 0):
	#		sliding_bug_fix(1)


func _on_slope_right_slope_r():
	#print(slide_buffer_timer)
	#print(downair_timer)
	if  (downairing and downair_timer < 0) or (slide_buffer_timer > 0):	
			#testnum += 1
			#print(testnum)
			velocity.x = (-max_speed*1.5)
			downairing = false
			#lock_abilities = false
			sliding = true
			downair_timer = downair_delay
			downair_cooldown = 0
	if (charging_buffer_timer):
		is_jumping = true
		jump_buffer_timer = 0
		velocity.y = -(jump_force*1.5)
		velocity.x *= 0.2
		#movement_enabled = true
		lock_abilities = false
		gravity_enabled = true
		charging_buffer_timer = false
		dash_timer = 0.3
		dashes_remaining = 1
		dash_cooldown = dash_cool * 0.7
		
	#else:
	#	if  (downairing or slide_buffer_timer > 0):
	#		sliding_bug_fix(-1)
"""
func sliding_bug_fix(direction: float) -> void:
	slidingbug = true
	slidingdirection = direction
	if downair_timer < 0:	
		velocity.x = (slidingdirection * max_speed*1.5)
		downairing = false
		#lock_abilities = false
		sliding = true
		downair_timer = downair_delay
		downair_cooldown = 0
		slidingbug = false
"""
func downair_logic(_delta: float) -> void:
	if is_on_floor():
		lock_abilities = false
		downairing = false
		downair_timer = downair_delay
		downair_cooldown = 0
		slide_buffer_timer = slide_buffer
		return			
	elif get_input()["down"] and downair_cooldown < 0: #downair_timer == 0:
		downair_timer = downair_delay
		downair_cooldown = downair_cool
		lock_abilities = true
		downairing = true
	if 	downair_timer < 0:
		velocity.y = gravity_max * downair_mult
		downairing = true
		#if slidingbug:
		#	sliding_bug_fix(slidingdirection)
	else:
		velocity.y = 10



func kick_logic(_delta: float) -> void:
	if is_on_floor():	
		if get_input()["down"] and kick_timer < 0 and get_input()["x"] != 0 and kick_cooldown < 0:
			kick_timer = kick_length
			kicking_direction = get_input()["x"]
			kicking = true
		if kick_timer > 0:
			velocity.x = max_speed * kick_speed * kicking_direction
			movement_enabled = false
		elif kicking == true:
			kick_cooldown = kick_cool
			velocity.x = 0
			movement_enabled = true
			kicking = false
	else:
		if jump_buffer_timer > 0 and is_jumping and get_input()["x"] != 0:
			velocity.y = gravity_max * comet_kick_mult
			velocity.x = max_speed * kick_speed * get_input()["x"]
			kicking = true
		
func raycast_on_wall():
	return (is_on_wall() or $RayCast2D.is_colliding() or $RayCast2D2.is_colliding() or $RayCast2D3.is_colliding() or $RayCast2D4.is_colliding() or $RayCast2D5.is_colliding() or $RayCast2D6.is_colliding()) 	

func get_raycast_normal():
	if $RayCast2D.is_colliding():
		print("1")
		return $RayCast2D.get_collision_normal()
	elif $RayCast2D2.is_colliding():
		print("2")
		return $RayCast2D2.get_collision_normal()
	elif $RayCast2D3.is_colliding():
		print("3")
		return $RayCast2D3.get_collision_normal()
	elif $RayCast2D4.is_colliding():
		print("4")
		return $RayCast2D4.get_collision_normal()
	elif $RayCast2D5.is_colliding():
		print("5")
		return $RayCast2D5.get_collision_normal()
	elif $RayCast2D6.is_colliding():
		print("5")
		return $RayCast2D6.get_collision_normal()

func set_abilities(wj: bool, da: bool , cd: bool ):
	wall_jump = wj
	down_air = da
	charge_dash = cd

func timers(delta: float) -> void:
	# Using timer nodes here would mean unnececary functions and node calls
	# This way everything is contained in just 1 script with no node requirements
	if (jump_coyote_timer) >= 0:
		jump_coyote_timer -= delta
	if (jump_buffer_timer) >= 0:
		jump_buffer_timer -= delta
	if (dash_buffer_timer) >= 0:
		dash_buffer_timer -= delta
	if (dash_cooldown) >= 0:
		dash_cooldown -= delta
	if (walljump_coyote_timer) >= 0:
		walljump_coyote_timer -= delta
	if (wallmove_timer) >= 0:
		wallmove_timer -= delta
	if (downair_timer) >= 0:
		downair_timer -= delta
	if (downair_cooldown) >= 0:
		downair_cooldown -= delta
	if (slide_buffer_timer) >= 0:
		slide_buffer_timer -= delta
	if (charge_timer) >= 0:
		charge_timer -= delta
	if (chargedelay_timer) >= 0:
		chargedelay_timer -= delta
	#if (charging_buffer_timer) >= 0:
	#	charging_buffer_timer -= delta
	if (kick_timer) >= 0:
		kick_timer -= delta
	if (kick_cooldown) >= 0:
		kick_cooldown -= delta
	
