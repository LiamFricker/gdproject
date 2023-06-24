class_name Player
extends CharacterBody2D
## This character controller was created with the intent of being a decent starting point for Platformers.
## 
## Instead of teaching the basics, I tri_d to implement more advanced considerations.
## That's why I call it 'Movement 2'. This is a sequel to learning demos of similar a kind.
## Beyond coyote time and a jump buffer I go through all the things listed in the following video:
## https://www.youtube.com/watch?v=2S3g8CgBG1g
## Except for separate air and ground acceleration, as I don't think it's necessary.

var test_num = 0
var testnum = 0

#tile map processing variables (stolen from https://www.youtube.com/watch?v=k9RsnbP4a0c)
#var current_tilemap: TileMap
#var current_terrain_area: TerrainArea
#var current_dive_spot_data: DiveSpotData
#var previous_terrain: int = -1
#var current_terrain: int = -1

# health and other  VARAIABLES ---------------- #
@export var health: float = 100
@export var invulnerability_time: float = 1
var invulnerability_timer = 0
var playerHurt = false
var knockback_mult = 1
var stun_mult = 1
@export var stun_time: float = 1
var stun_timer  = 0
#var stunned = false
var knockback_direction = 1
@export var knockback_x: float = 250
@export var knockback_y: float = -800

#mana variables
@export var max_mana: float = 100
var mana = 100

var money = 0

# melee  VARAIABLES ---------------- #
@export var melee0: PackedScene

#this is used for choosing melee attack
var melee
#implement a way to choose melee attacks 

@export var attack_speed = 5
@export var attack_dmg = 2
@export var attack_reach = 1
var attack_delay = 0.1
var attack_delay_timer = 0

var melee_stacks = 0
@export var melee_stack_loss = 0.5
var stack_loss_timer = 0 

var speed_delayed = 0
#var speed_delayeder = 0
#var start_speed_storing = true
#var speed_storing = false

@export var speed_delay_1 = 0.5
#@export var speed_delay_2 = 1
#@export var StationaryDelay = 0.25
var speed_delaying_1 = 0
#var speed_delaying_2 = 0 
#var StationaryTimer = 0

# special  VARAIABLES ---------------- #
@export var special0 = PackedScene
@export var special1 = PackedScene 
@export var special2 = PackedScene 

var special_num = 1 
var special_num0 = 1

@export var auto_switch: bool = true
var special_stacks = 0
@export var special_cooldown: float = 6
var special_cooldown_timer = 0
@export var special_cooldown0: float = 6
var special_cooldown_timer0 = 0

func special_rotate(num : bool) -> void: 
	if num:
		#special_cooldown_timer = special_cooldown 
		special_cooldown_timer = 0  
		#print(special_num)
		special_num = (special_num % 3) + 1 
	else:
		special_cooldown_timer0 = 0
		special_num0 = (special_num0 % 3) + 1 

#You want to make this an array later so you can have multiple special attacks at once
var special

@export var intellegence = 1


# BASIC MOVEMENT VARAIABLES ---------------- #
var attack_mult := 1
var face_direction := 1
var facing_direction := 1
var kicking_direction := 1
var x_dir := 1
var movement_enabled := true
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

var dash_attack_used = true
@export var dash_attack0: PackedScene
var dash_attack = dash_attack0
# ------------------------------------------ #

# CHARGE DASH VARAIABLES ------------------- #
@export var charge_dash : bool = true
@export var charge_x_mult : float = 1
@export var charge_y_mult : float = 1
@export var charge_time : float = 1.5
var charge_timer : float = charge_time
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
var walljump_direction = 0
# ----------------------------------- #

# DOWN AIR VARIABLES ------------------- #
@export var down_air : bool = true
var attacking = false
@export var downair_delay : float = 0.20
var downair_timer : float = 0
@export var downair_cool : float = 1
var downair_cooldown : float = 0
@export var downair_mult : float = 1.75
@export var downair_x : float = 0.25
var lock_abilities : bool = false
var downairing : bool = false

var down_air_attack_used = true
@export var down_air_attack0: PackedScene
var down_air_attack = down_air_attack0

var down_air_jump = false

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
		"attack": Input.is_action_just_pressed("attack") == true,
		"special": Input.is_action_just_pressed("special") == true
	}


func _physics_process(delta: float) -> void:
	speed_storage()
	if(not lock_abilities):	
		dash_logic(delta)
	else:
		if Input.is_action_just_released("dash"):
			charge_timer = charge_time
			chargedash_length = dash_length
			chargedash_speed = dash_speed
	x_movement(delta)
	if(not playerHurt):	
		jump_logic(delta)
	apply_gravity(delta)
	if (raycast_on_wall() and gravity_enabled and velocity.y >= 0 and (not lock_abilities or attack_delay_timer >= 0.1) and wall_jump and not playerHurt):# or walljump_coyote_timer > 0):
		walljump_logic(delta)
	if (get_input()["down"] or downairing) and gravity_enabled and down_air and not attacking and not playerHurt:	
		downair_logic(delta)
		
	if (get_input()["down"] and is_on_floor() and gravity_enabled):
		drop_through_platforms()
	#if(gravity_enabled and slidekick):	
		#kick_logic(delta)
	if(get_input()["attack"] and attack_delay_timer <= 0 and not downairing and dash_timer <= 0):
		melee_attack(melee0)
	if(attack_delay_timer >= 0.1 and wallmove_timer <= 0):
		melee_attacking()
	if get_input()["special"]:
		#get_parent().special_cast(special2, position, intellegence*4, velocity.x, face_direction)
		if special_cooldown_timer <= 0:
			#print("true")
			special_attack(true)
		elif special_cooldown_timer0 <= 0:
			special_attack(false)
	if(playerHurt):
		knockback_logic()
	if(health <= 0):
		get_parent().get_parent().game_over()
	timers(delta)
	move_and_slide()

func speed_storage() -> void:
	#easy way to code this
	#print("speed 1")
	#print(speed_delayed)
	if abs(velocity.x) > 400:
		if speed_delayed < abs(velocity.x):
			speed_delayed = abs(velocity.x)
			speed_delaying_1 = speed_delay_1
		elif speed_delaying_1 <= 0:
			speed_delayed = abs(velocity.x)
	else:
		if speed_delaying_1 <= 0:
			speed_delayed = 0
	#print(speed_delaying_2)
	#hard and complicate way to code this
	"""
	print("speed 0.25")
	print(speed_delayed)
	print("speed 0.5")
	print(speed_delayeder)
	"""
	"""
	if abs(velocity.x) > 400:
		StationaryTimer = StationaryDelay
		if start_speed_storing:
			#speed_storing = true
			start_speed_storing = false
			speed_delaying_1 = speed_delay_1
			speed_delaying_2 = speed_delay_2
	else:
		if StationaryTimer <= 0:
			#print("Stationary Reset")
			start_speed_storing = 0	
			start_speed_storing = true
			speed_delaying_1 = speed_delay_1
			speed_delaying_2 = speed_delay_2
	if speed_delaying_1 <= 0:
		#print("Speed 1 Reset")
		speed_delaying_1 = speed_delay_1
		speed_delayed = abs(velocity.x)
	if speed_delaying_2 <= 0:
		#print("Speed 2 Reset")
		speed_delaying_2 = speed_delay_2
		speed_delayeder = abs(velocity.x)
	"""
#func _on_stationary_timer_timeout():
#	start_speed_storing = true

	
func speed_equals_damage():
	if speed_delayed >= 800:# or speed_delayeder >= 800:
		speed_delayed = 0
		return 2
	elif speed_delayed >= 500:# or speed_delayeder >= 500:
		return 1.2
	else: 
		return 1
		
func melee_attack(melee_used : PackedScene) -> void:
	if stack_loss_timer <= 0 or jump_buffer_timer >= 0:
		melee_stacks = 0
	melee_stacks += 1
	stack_loss_timer = melee_stack_loss + attack_delay
	melee = melee_used.instantiate()
	if melee_stacks >= 3:
		melee.setParams(attack_speed, 2*attack_dmg*speed_equals_damage(), attack_reach, true)
		melee_stacks = 1
		attack_delay = (1.0/attack_speed) + 0.1 + 0.1
	else:
		melee.setParams(attack_speed, attack_dmg*speed_equals_damage(), attack_reach, false)
		attack_delay = (1.0/attack_speed) + 0.1 + 0.1
	attack_delay_timer = attack_delay
	add_child(melee)
	facing_direction = face_direction

func special_attack(num : bool) -> void:
	#if auto_switch:	
	#	special_stacks -= 1
	if num:	
		if special_num == 1 and mana >= 30:
			get_parent().get_node("AbilitySpawner").special_cast(special0, position, intellegence*4, velocity.x, face_direction)
			#if special_stacks <= 0:
			special_cooldown = 6
			mana -= 30
			#get_parent().special_rotate()
			#	special_stacks = 1
		elif special_num == 2 and mana >= 20:
			get_parent().get_node("AbilitySpawner").special_cast(special1, position, intellegence*4, velocity.x, face_direction)
			#if special_stacks <= 0:
			special_cooldown = 2
			mana -= 20
			#get_parent().special_rotate()
			#	special_stacks = 1
		elif special_num == 3 and  mana >= 35: 
			get_parent().get_node("AbilitySpawner").special_cast(special2, position, intellegence*4, velocity.x, face_direction)
			#if special_stacks <= 0:
			special_cooldown = 8
			mana -= 35
		special_cooldown_timer = special_cooldown 
	else:
		if special_num0 == 1 and mana >= 30:
			get_parent().get_node("AbilitySpawner").special_cast(special0, position, intellegence*4, velocity.x, face_direction)
			#if special_stacks <= 0:
			special_cooldown0 = 6
			mana -= 30
			#get_parent().special_rotate()
			#	special_stacks = 1
		elif special_num0 == 2 and mana >= 20:
			get_parent().get_node("AbilitySpawner").special_cast(special1, position, intellegence*4, velocity.x, face_direction)
			#if special_stacks <= 0:
			special_cooldown0 = 2
			mana -= 20
			#get_parent().special_rotate()
			#	special_stacks = 1
		elif special_num0 == 3 and  mana >= 35: 
			get_parent().get_node("AbilitySpawner").special_cast(special2, position, intellegence*4, velocity.x, face_direction)
			#if special_stacks <= 0:
			special_cooldown0 = 8
			mana -= 35
		#get_parent().special_rotate()
		#	special_stacks = 1
		#	playerhealth += 10
		special_cooldown_timer0 = special_cooldown0 

func melee_attacking() -> void:
	#movement_enabled = false
	lock_abilities = true
	#wall_jump = false
	attacking = true
	velocity.x *= 1
	set_direction(facing_direction)
	#remove_child(special)

func drop_through_platforms() -> void:
	#set_collision_mask_value(4,  false)
	call_deferred("set_collision_mask_value", 4, false)
	$PlatformCollisionTimer.start()
	
func _on_platform_collision_timer_timeout():
	#set_collision_mask_value(4,  true)
	call_deferred("set_collision_mask_value", 4, true)

func dash_logic(_delta: float) -> void:
	if is_on_floor_only():
		dashes_remaining = 1
	if charge_dash:
		if Input.is_action_just_pressed("dash") and dash_buffer_timer < 0 and dash_timer <= 0:
			#print("dash pressed")
			chargedelay_timer = charge_delay
			charge_timer = charge_time
			chargedash_length = dash_length
			chargedash_speed = dash_speed
			# + charge_delay 
		if Input.is_action_pressed("dash"):
			if chargedelay_timer < 0 and dash_timer <= 0: #and dash_cooldown <= 0:	
				#print(dash_buffer_timer)
				#print(dash_timer)
				chargedash_length = dash_length * (2.5-(charge_timer*(1.5/(charge_time - charge_delay)))) 
				chargedash_speed = dash_speed * (1.75-(charge_timer*0.5*(1.5/(charge_time - charge_delay))))
		if Input.is_action_just_released("dash") and sliding == false:
			dash_buffer_timer = dash_buffer	

			if dash_cooldown > dash_buffer and dash_timer < 0:
				#This is if you click it when on cooldown
				chargedelay_timer = charge_delay
				charge_timer = charge_time
				chargedash_length = dash_length
				chargedash_speed = dash_speed
			#print(dash_cooldown)
			#print(dash_buffer)
			#print(dash_timer)
			#print(chargedash_length)
			#print(chargedash_speed)
			#print(chargedash_length)
			#print(chargedash_speed)
		if dash_buffer_timer > 0 and dash_timer <= 0 and (dash_cooldown <= 0) and dashes_remaining == 1:
			facing_direction = face_direction
			dash_timer = chargedash_length/chargedash_speed
			dash_cooldown = dash_cool
			dashes_remaining = 0
			movement_enabled = false
			gravity_enabled = false
			charging_buffer_timer = true
			charge_timer = charge_time
			if is_on_floor():	
				velocity.x = facing_direction * (chargedash_speed)#+ velocity.x * 0.25)#(max_speed * 100.25))
				dash_timer += 1
				#print(velocity.x)
				return
			velocity.x = (chargedash_speed * facing_direction)
			#print(dash_timer)
			#print(chargedash_speed)
			#print(velocity.x)
		elif (dash_timer) > 0:
			dash_timer -= 0.4
			melee_stacks = 0
			if (dash_timer) <= 0:
				velocity.x *= 0.2
				movement_enabled = true
				gravity_enabled = true
				chargedash_length = dash_length
				chargedash_speed = dash_speed
				charging_buffer_timer = false
				dash_attack_used = true
				if 	dash_attack != null: 
					dash_attack.queue_free()
				return
			if dash_attack_used:
				dash_attack = dash_attack0.instantiate()
				dash_attack.setParams(attack_dmg)
				add_child(dash_attack) 
			dash_attack_used = false
			if is_on_floor():	
				velocity.x = facing_direction * (chargedash_speed + (max_speed * 0.25))
				dash_cooldown = dash_cool * 1.5
				#print(velocity.x)
				return
			velocity.x = (chargedash_speed * facing_direction)
			#print(dash_timer)
			#print(chargedash_speed)
			#print(velocity.x)
	else:
		if Input.is_action_just_pressed("dash"):
			dash_buffer_timer = dash_buffer	
		if dash_buffer_timer > 0 and dash_timer <= 0 and (dash_cooldown <= 0) and dashes_remaining == 1:
			facing_direction = face_direction
			dash_timer = dash_length/dash_speed
			dash_cooldown = dash_cool
			dashes_remaining = 0
			movement_enabled = false
			gravity_enabled = false
			if is_on_floor():	
				velocity.x = (dash_speed * facing_direction) + (max_speed * facing_direction * 0.35)
				dash_cooldown = dash_cool# * 1.2
				return
			velocity.x = (dash_speed * facing_direction)
			
		elif (dash_timer) > 0:
			melee_stacks = 0
			dash_timer -= 0.4
			if (dash_timer) <= 0:
				velocity.x *= 0.2
				movement_enabled = true
				gravity_enabled = true
				dash_attack_used = true
				if 	dash_attack != null: 
					dash_attack.queue_free()
				return
			if dash_attack_used:
				dash_attack = dash_attack0.instantiate()
				dash_attack.setParams(attack_dmg)
				add_child(dash_attack) 
			dash_attack_used = false
			if is_on_floor():	
				velocity.x = (dash_speed * facing_direction) + (max_speed * facing_direction * 0.35)
				return
			velocity.x = (dash_speed * facing_direction)
			

func get_dashcooldown():
	return ((dash_cool-dash_cooldown)/dash_cool) * 100

func get_dashcharge():
	return ((charge_time-charge_timer)/charge_time) * 100

func x_movement(delta: float) -> void:
	#if dash_timer > 0:
	#	velocity.x = (dash_speed*(sign(velocity.x)))
	#	return
	if (playerHurt): 
		return
	elif (not movement_enabled and wallmove_timer >= 0):
		x_dir = 0
		set_direction(get_input()["x"])
	elif sliding:
		if abs(velocity.x) >= 500:
			return
		x_dir = get_input()["x"]
		lock_abilities = false
		sliding = false
	else:
		x_dir = get_input()["x"]
	if dash_timer > 0 or playerHurt:
		x_dir = facing_direction
	set_direction(x_dir)
	
	
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
	apply_scale(Vector2(hor_direction * face_direction, 1))# flip
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
		melee_stacks = 0
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
		set_direction(sign(get_wall_normal().x))	
		#walljump_direction = sign(get_wall_normal().x)
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
		set_direction(-sign(get_wall_normal().x))
	if jump_buffer_timer > 0:# 
		is_jumping = true
		jump_buffer_timer = 0
		walljump_coyote_timer = 0
		# If falling, account for that lost speed
		if velocity.y > 0:
			velocity.y -= velocity.y
		if is_on_wall():
			velocity.x += (walljump_push * sign(get_wall_normal().x))
			set_direction(sign(get_wall_normal().x))
		elif raycast_on_wall():
			velocity.x += (walljump_push * sign(get_raycast_normal().x))
			set_direction(sign(get_raycast_normal().x))
		#elif walljump_coyote_timer > 0:
		#	velocity.x += (walljump_push * walljump_direction)
		velocity.y = -(jump_force * 0.85)
		movement_enabled = false
		wallmove_timer = wallmove_cooldown
		
		
	
func _on_bouncer_bounce(extra_arg_0):
	#check if down airing
	if  (downairing and downair_timer < 0) or (slide_buffer_timer > 0):
		var bouncer = get_node(extra_arg_0)		
		bouncer._bounce()
		is_jumping = true
		jump_buffer_timer = 0
		velocity.y = -(jump_force*1.5)
		downairing = false
		lock_abilities = false
		downair_timer = downair_delay
		downair_cooldown = 0
		dashes_remaining = 1
		down_air_attack_used = true
		down_air_jump = false
		if 	down_air_attack != null: 
			down_air_attack.queue_free()


func _on_brick_brickbreak(extra_arg_0):
	if  (downairing and downair_timer < 0) or (slide_buffer_timer > 0):
		var brick = get_node(extra_arg_0)
		brick.destroy()

func _on_block_blockbreak(extra_arg_0):
	if (charging_buffer_timer):
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
		set_direction(1)
		dashes_remaining = 1
		down_air_attack_used = true
		down_air_jump = false
		if 	down_air_attack != null: 
			down_air_attack.queue_free()
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
			set_direction(-1)
			dashes_remaining = 1
			down_air_attack_used = true
			down_air_jump = false
			if 	down_air_attack != null: 
				down_air_attack.queue_free()
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
		down_air_attack_used = true
		down_air_jump = false
		if 	down_air_attack != null: 
			down_air_attack.queue_free()
		return			
	elif get_input()["down"] and downair_cooldown < 0: #downair_timer == 0:
		downair_timer = downair_delay
		downair_cooldown = downair_cool
		lock_abilities = true
		downairing = true
	if 	downair_timer < 0:
		velocity.y = gravity_max * downair_mult
		if down_air_attack_used:
			down_air_attack = down_air_attack0.instantiate()
			down_air_attack.setParams(attack_dmg)
			add_child(down_air_attack) 
		downairing = true
		down_air_attack_used = false
		#if slidingbug:
		#	sliding_bug_fix(slidingdirection)
	else:
		velocity.y = 10


"""
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
"""		
func raycast_on_wall():
	return (is_on_wall() or $RayCast2D4.is_colliding() or $RayCast2D.is_colliding())# or $RayCast2D2.is_colliding() or $RayCast2D3.is_colliding() or $RayCast2D4.is_colliding() or $RayCast2D5.is_colliding() or $RayCast2D6.is_colliding()) 	

func get_raycast_normal():
	
	if $RayCast2D.is_colliding():
		return $RayCast2D.get_collision_normal()
	
	if $RayCast2D4.is_colliding():
		return $RayCast2D4.get_collision_normal()
	"""
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
	"""

func _on_hitbox_area_entered(area):
	if down_air_jump:

		is_jumping = true
		jump_buffer_timer = 0
		velocity.y = -(jump_force*1.25)	
		downairing = false
		lock_abilities = false
		downair_timer = downair_delay
		downair_cooldown = 0
		dashes_remaining = 1
		down_air_attack_used = true
		if 	down_air_attack != null: 
			down_air_attack.queue_free()
		$DownAirJumpTimer.start()
		
	elif invulnerability_timer <= 0:
		invulnerability_timer = invulnerability_time 
		health -= area.get_parent().dmg
		playerHurt = true
		stun_timer = stun_time
		#stunned = true
		movement_enabled = false
		lock_abilities = true
		gravity_enabled = true
		charging_buffer_timer = false
		dash_timer = 0
		downairing = false
		down_air_attack_used = true
		down_air_jump = false
		if 	down_air_attack != null: 
			down_air_attack.queue_free()
		knockback_direction = -sign(area.get_parent().position.x - position.x + 1)
		velocity.y = knockback_y
		velocity.x = knockback_x * knockback_direction * knockback_mult
		$Sprite._playHurt()
		dash_attack_used = true
		if 	dash_attack != null: 
			dash_attack.queue_free()

func _on_hitbox_body_entered(_body):
	pass
	"""
	if down_air_jump:

		is_jumping = true
		jump_buffer_timer = 0
		velocity.y = -(jump_force*1.25)	
		downairing = false
		lock_abilities = false
		downair_timer = downair_delay
		downair_cooldown = 0
		dashes_remaining = 1
		down_air_attack_used = true
		if 	down_air_attack != null: 
			down_air_attack.queue_free()
		$DownAirJumpTimer.start()
		
	elif invulnerability_timer <= 0:
		invulnerability_timer = invulnerability_time 
		playerhealth -= body.dmg
		playerHurt = true
		stun_timer = stun_time
		#stunned = true
		movement_enabled = false
		lock_abilities = true
		gravity_enabled = true
		charging_buffer_timer = false
		dash_timer = 0
		downairing = false
		down_air_attack_used = true
		down_air_jump = false
		if 	down_air_attack != null: 
			down_air_attack.queue_free()
		knockback_direction = -sign(body.position.x - position.x + 1)
		velocity.y = knockback_y
		velocity.x = knockback_x * knockback_direction * knockback_mult
		$Sprite._playHurt()
		dash_attack_used = true
		if 	dash_attack != null: 
			dash_attack.queue_free()
	"""

func _on_hitbox_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index) -> void:
	if body is TileMap:
		if invulnerability_timer <= 0:
			invulnerability_timer = invulnerability_time * 1.5
			#playerhealth -= _process_tilemap_collision(body,body_rid)
			health -= 5
			playerHurt = true
			stun_timer = stun_time * 1
			#stunned = true
			movement_enabled = false
			lock_abilities = true
			gravity_enabled = true
			charging_buffer_timer = false
			dash_timer = 0
			downairing = false
			down_air_attack_used = true
			down_air_jump = false
			if 	down_air_attack != null: 
				down_air_attack.queue_free()
			#knockback_direction = -sign(body.get_coords_for_body_rid(body_rid).x - position.x + 1)
			knockback_direction = -sign(1)
			velocity.y = knockback_y * 1.5
			velocity.x = knockback_x * knockback_direction * knockback_mult * 1.5
			$Sprite._playHurt()
			dash_attack_used = true
			if 	dash_attack != null: 
				dash_attack.queue_free()
		
#func _process_tilemap_collision(body: Node2D, body_rid: RID):
	#This is a bad appropriation of the code in the video, but this is all the use I have for it rn
	#nevermind it doesn't work and I'm too lazy to care
#	pass
	"""
	current_tilemap = body
	print(body)
	var collided_tile_coords = -current_tilemap.get_coords_for_body_rid(body_rid)
	print(collided_tile_coords)
	
	var tile_data = current_tilemap.get_cell_tile_data(1, collided_tile_coords)
	print(body.get_layers_count())
	return tile_data.get_custom_data_by_layer_id(0)
	

	for index in current_tilemap.get_layers_count():
		var tile_data = current_tilemap.get_cell_tile_data(index,collided_tile_coords)
		print(index)
		#print(tile_data)
		#print(tile_data.get_custom_data_by_layer_id(0))
		if !tile_data is TileData:
			print("failed")
			continue
		else:
			return tile_data.get_custom_data_by_layer_id(0)
		print(tile_data)
		print(tile_data.get_custom_data_by_layer_id(0))
	return 0
	"""
func sicklerang_return():
	print("You caught the sicklerang!")
	if special_num == 3:	
		special_cooldown_timer = 0
	elif special_num0 == 3:
		special_cooldown_timer0 = 0
func knockback_logic():
	
	if stun_timer <= 0.3:
		movement_enabled = true
		lock_abilities = false
		playerHurt = false
	elif stun_timer <= 0.4:
		velocity.x = 0
		$Sprite.isNotHurt = true
		#velocity.y += knockback_y

		

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
	if (charge_timer) >= 0 and Input.is_action_pressed("dash"):
		charge_timer -= delta
	if (chargedelay_timer) >= 0:
		chargedelay_timer -= delta
	#if (charging_buffer_timer) >= 0:
	#	charging_buffer_timer -= delta
	if (kick_timer) >= 0:
		kick_timer -= delta
	if (kick_cooldown) >= 0:
		kick_cooldown -= delta
	if (invulnerability_timer) >= 0:
		invulnerability_timer -= delta
	if (stun_timer) >= 0:
		stun_timer -= delta
	if(attack_delay_timer) >= 0:
		attack_delay_timer -= delta
		if attack_delay_timer < 0.1:
			#movement_enabled = true
			lock_abilities = false
			#wall_jump = true
			attacking = false
			attack_mult = 1
	if(stack_loss_timer) >= 0:
		stack_loss_timer -= delta	
	if(special_cooldown_timer) > 0:
		special_cooldown_timer -= delta
	if(special_cooldown_timer0) > 0:
		special_cooldown_timer0 -= delta
	if(speed_delaying_1) > 0:
		speed_delaying_1 -= delta
	"""
	if(speed_delaying_2) > 0:
		speed_delaying_2 -= delta
	if(StationaryTimer) > 0:
		StationaryTimer -= delta
	"""
func _on_down_air_jump_timer_timeout():
	down_air_jump = false
