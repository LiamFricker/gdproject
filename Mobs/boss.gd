extends CharacterBody2D

enum  {
	SWITCH,
	IDLE,
	WALKING,
	SPIKES, 
	SIDE,
	SPIT,
	LAUGHING, 
	SUBMERGED,
	DEATH 
}

@onready var AP = $Sprite/AnimationPlayer


@export var health: float = 50
@onready var max_health = health
@export var dmg: float = 1
@export var gravity: float = 1020
@export var dir : float = 1

@export var near_start = false
@export var boss = false

@onready var start_x = position.x
var player_behind = false

var state = IDLE
var state_queue = [IDLE, IDLE, IDLE, IDLE]
var start = true

var attack_number = 0
var submerged = false
var t_rotation = 0
var phase = 1

func _on_hurtbox_area_entered(area):
	#if $DeathTimer.is_stopped():
		health -= area._getDamage()
		if health > 0:
			#$Sprite._playHurt()
			$Sprite/AnimationPlayer2.play("Hit")
		else:
			#Make this queue death instead
			#state = SWITCH
			state_queue[0] = DEATH
			start = true
			$DeathTimer.start()
			#print(state_queue[0])
			"""
			$Sprite/AnimatedSprite2D.visible = false
			$Sprite/AnimatedSprite2D2.visible = true
			$Sprite/AnimatedSprite2D2.play("Death")
			$DeathTimer.start()
			"""
			pass
			#if submerged: Queue Unsubmerge Queue[0] Death
			#else Queue Death

func _on_hurtbox_body_entered(body):
	#if $DeathTimer.is_stopped():
		health -= body._getDamage()
		if health > 0:
			#$Sprite._playHurt()
			$Sprite/AnimationPlayer2.play("Hit")
		else:
			#Make this queue death instead
			#state = SWITCH
			state_queue[0] = DEATH
			start = true
			$DeathTimer.start()
			#print(state_queue[0])
			"""
			$Sprite/AnimatedSprite2D.visible = false
			$Sprite/AnimatedSprite2D2.visible = true
			$Sprite/AnimatedSprite2D2.play("Death")
			$DeathTimer.start()
			"""
			pass
			#if submerged: Queue Unsubmerge Queue[0] Death
			#else Queue Death

#Super important 
func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"Laugh":
			state = SWITCH
			start = true
		"Spikes":
			state = SWITCH
			start = true
		"Side Attack":
			state = SWITCH
			start = true
			if player_behind:
				apply_scale(Vector2(-1,1))
				player_behind = false
		"Spit":
			state = SWITCH
			start = true
		"Submerge":
			state = SWITCH
			start = true
			"""
			if submerged:
				print("t_rot = 1")
				t_rotation += 1
			else:
				print("to switch state")
			"""				
		#"TentacleSpike":
		#	t_rotation += 1
		#"TentacleRotation1":
		#	AP.play("TentacleSpike")
		#"TentacleRotation2":
		#	AP.play("TentacleSpike")
		"TentacleRotation3":
			submerged = false
			AP.play_backwards("Submerge")
		"Death":
			if boss:
				get_parent().get_parent()._level_complete()
			queue_free()
		


func _process(_delta):
		#print(state)
		#if health > 0:
		#if state != LAUGHING and state != SUBMERGED and get_parent().get_node("Player").playerHurt:
		#	state_queue[1] = LAUGHING
		if phase == 1 and health <= max_health * 2/3:
			#print("phase 2")
			phase = 2
			state_queue[2] = SUBMERGED
			t_rotation = 0
		elif phase == 3 and health <= max_health * 1/3:
			#print("phase 3")
			phase = 4
			state_queue[2] = SUBMERGED
			t_rotation = 0
		match state:
			SWITCH:
				switch_state()
			IDLE:
				idling()
			WALKING:
				walking()
			SPIKES:
				spikes_attack()
			SIDE:
				side_attack()
			SPIT:
				spit_attack()
			LAUGHING:
				laugh() 
			SUBMERGED:
				submerged_state()
			DEATH:
				#print("death started")
				death()

func death():
	velocity.x = 0
	if start and not submerged:
		AP.play("Death")
		start = false

func switch_state() -> void:
	#queue[0] = death
	#queue[1] = laugh
	#queue[2] = submerge
	#queue[3] = next state
	#print("switch state")
	#print("switch state entered")
	if state_queue[0] != IDLE:
		print("death queued")
		state = state_queue[0]
		state_queue[0] = IDLE
	elif state_queue[1] != IDLE:
		state = state_queue[1] 
		state_queue[1] = IDLE
	elif state_queue[2] != IDLE:
		#print("submerged queued")
		state = state_queue[2]
		state_queue[2] = IDLE
		start = true
	elif state_queue[3] != IDLE:
		#print("state queued")
		state = state_queue[3]
		state_queue[3] = IDLE
	else:
		state = IDLE

func idling() -> void:
	velocity.x = 0
	#state = SWITCH
	if start:
		#print("idle")
		$IdleTimer.start()
		start = false

func _on_idle_timer_timeout():
	#print("idle timer timeout")
	if state == IDLE: 
		state = SWITCH	
		state_queue[3] = WALKING
	start = true


func walking() -> void:
	if start:
		var walk_rng = RandomNumberGenerator.new()
		$WalkTimer.wait_time = 1.2 + 0.6 * walk_rng.randi_range(1, 3) if state < 4 else 0.6 + 0.6 * walk_rng.randi_range(1, 2)
		#Calculate random amount of distance to move. Check if there is space. If at 
		#a certain distance, turn around and walk the remainder in other direction 
		#Has to be in an interval of 1.2, 2.4, 3.6, 4.8 with some leeway to go with animation
		$WalkTimer.start()
		start = false
	if abs(start_x - position.x) > 500 and $ChangeDirectionCooldown.is_stopped():
		#print("change direction")
		dir *= -1
		apply_scale(Vector2(-1,1))
		$ChangeDirectionCooldown.start()	
	AP.play("Walk")
	velocity.x = dir * 100 if state < 4 else dir * 150

func _on_walk_timer_timeout():
	#print("walk timer timeout")
	if state == WALKING: 	
		state = SWITCH	
		state_queue[3] = choose_attack()
	start = true
	velocity.x = 0

func choose_attack():
	var rng = RandomNumberGenerator.new()
	attack_number = rng.randi_range(1, 5) if phase <= 2 else (rng.randi_range(2, 6) if phase <= 4 else rng.randi_range(3, 6))
	while true:
		match attack_number:
			1,2:
				if abs(get_parent().get_node("Player").position.x - position.x) < (300):
					return SPIKES
				else:
					attack_number = rng.randi_range(3, 5)
			3,4:
				return SPIT
			5,6:		
				#if true: #check if enough space
				return SIDE
				#else:
				#	attack_number = rng.randi_range(1, 4)
	
func spikes_attack():
	if start:
		AP.play("Spikes")
		start = false

func side_attack():
	if start:
		if (get_parent().get_node("Player").position.x - position.x) * dir < (-10):
			player_behind = true
			apply_scale(Vector2(-1,1))
		AP.play("Side Attack")
		start = false
	
func spit_attack():
	#Gonna have to create the bomb child nodes for this one
	#BING CHILLING~!?!?!!?!?!?!! 
	#NO I DO NOT WANT TO BOMB CHILDREN HOLY FUCK AGGH
	if start:
		AP.play("Spit")
		$SpitTimer.start()
		start = false

func _on_spit_timer_timeout():
	var spit_rng = RandomNumberGenerator.new()
	get_parent().get_node("AbilitySpawner").create_bullet(Vector2(position.x -10 + dir * 40, position.y + 15), dmg, dir, spit_rng.randi_range(3, 4))
	if phase >= 3:
		get_parent().get_node("AbilitySpawner").create_bullet(Vector2(position.x -10 + dir * 40, position.y + 15), dmg, 2*dir, spit_rng.randi_range(3, 4))
	if phase >= 4:
		get_parent().get_node("AbilitySpawner").create_bullet(Vector2(position.x -10 + dir * 40, position.y + 15), dmg, 1.5*dir, spit_rng.randi_range(3, 4))

func laugh():
	#Play the laugh track
	#Not that one
	velocity.x = 0
	if start:
		AP.play("Laugh")
		start = false

func submerged_state():
	"""
	match t_rotation:
		0:
			pass
		1:
			pass
		2:
			pass
		3:
			pass
	"""
	if abs(start_x - position.x) > 10 and $ChangeDirectionCooldown.is_stopped():
		AP.play("Walk")
		velocity.x = sign(start_x - position.x) * 200
	elif start and state_queue[0] != DEATH:
		velocity.x = 0
		if phase == 2:
			phase = 3
		#print("submerge state started")
		submerged = true
		start = false
		AP.play("Submerge")
		AP.queue("TentacleRotation1")
		AP.queue("TentacleSpike")
		AP.queue("TentacleRotation2")
		AP.queue("TentacleSpike")
		AP.queue("TentacleRotation3")
		
	if state_queue[0] == DEATH and near_start and start == true:
		start = false
		AP.clear_queue()
		AP.play_backwards("Submerge")
		AP.queue("Death")
		
func _physics_process(delta):
	if not is_on_floor(): 
		velocity.y += gravity * delta
	move_and_slide()



func _on_death_timer_timeout():
	if boss:
		get_parent().get_parent()._level_complete()
	queue_free()
