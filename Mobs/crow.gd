extends CharacterBody2D

@export var health: float = 50
@export var dmg: float = 1
@export var gravity: float = 1020
@export var dir : float = 1

@export var ambush_height : float = 200
@export var jump_height : float = 200
var waiting = true

@export var cooldown : float = 3.75
var direction = 1
var upwards_velocity = -1 * jump_height * 12

var flying = false
var player_location = Vector2(0,0)
var player_distance = 350
var old_x = 0
var old_y = 0
var distance_icba_calculating = 0
var rotate = 0

"""
func _ready():
	$ShootingCooldown.wait_time = cooldown
	$AmbushRange.position.y = -1 * ambush_height * 1.2/0.8

func _on_ambush_range_body_entered(_body):
	$JumpTimer.start()
func _on_jump_timer_timeout():
	velocity.y = 0
	$AmbushRange.monitoring = false
	$DetectionRange.monitoring = true
	call_deferred("set_collision_mask_value", 2, true)
	call_deferred("set_collision_mask_value", 3, true)
	call_deferred("set_collision_mask_value", 4, true)
	waiting = false

func _on_detection_range_body_entered(_body):
	#$ShootingTimer.start()
	$ShootingCooldown.start()
	$DetectionRange.position.y += 10000
	$Sprite/AnimationPlayer.play("Attack")
	$ShootingTimer.start()
	
func _on_shooting_timer_timeout():
	get_parent().create_bullet(Vector2(position.x -10 + dir * 20, position.y - 20), dmg, dir, 1)	
	#bullet = fireball.instantiate()
	#bullet.setParams(dmg, scale.x)
	#add_child(bullet)

func _on_shooting_cooldown_timeout():
	$DetectionRange.position.y -= 10000
"""

func _on_hurtbox_area_entered(area):
	if $DeathTimer.is_stopped():
		health -= area._getDamage()
		if health > 0:
			#$Sprite._playHurt()
			$Sprite/AnimationPlayer2.play("Hit")
		else:
			#$Sprite._playDeath()
			#$PhysicsHitbox.disabled
			$Sprite/AnimatedSprite2D.visible = false
			$Sprite/AnimatedSprite2D2.visible = true
			$Sprite/AnimatedSprite2D2.play("Death")
			$Hitbox.set_deferred("monitorable", false)
			$DeathTimer.start()

func _on_hurtbox_body_entered(body):
	if $DeathTimer.is_stopped():
		health -= body._getDamage()
		if health > 0:
			#$Sprite._playHurt()
			$Sprite/AnimationPlayer2.play("Hit")
		else:
			#$PhysicsHitbox.disabled
			$Sprite/AnimatedSprite2D.visible = false
			$Sprite/AnimatedSprite2D2.visible = true
			$Sprite/AnimatedSprite2D2.play("Death")
			$Hitbox.set_deferred("monitorable", false)
			$DeathTimer.start()

#This is the fucking worst fuck this fuck this fuck AGGGGHH NEVER MESSING WITH FLOAT ROUNDING AGAIN
"""
func _physics_process(delta):
	player_location = get_parent().get_node("Player").position
	#print(player_location.y - position.y)
	#print(player_distance)
	if (player_location.x - position.x) * dir > (50) and 350 > 100 and (not flying) and $FlightCooldown.is_stopped():
		#print("flying")
		flying = true
		old_x = position.x
		player_distance = 2050
		#print((2 * distance_icba_calculating))
	if ((position.x - old_x + distance_icba_calculating) * dir > 900) and $FlightCooldown.is_stopped():
		#print(position.y)
		flying = false
		velocity.x = (500 * dir) * cos(deg_to_rad(-90+rotate))
		velocity.y = (-500) * sin(deg_to_rad(-90+rotate)) 
		if rotate >= 180:
			rotate = 0
			$FlightCooldown.start()
			dir *= -1
			apply_scale(Vector2(-1,1))
			velocity.y = 0
			velocity.x = 0
		else:
			rotate += 90 * player_distance/500 * delta
	if flying:
		#print("flying logic")
		#print(rotate)
		velocity.x = (500 * dir) * cos(deg_to_rad(90-rotate))
		velocity.y = (500) * sin(deg_to_rad(90-rotate)) 
		if rotate >= 90:
			rotate = 90
			
		else:
			rotate += 90 * player_distance/500 * delta
			distance_icba_calculating = (position.x - old_x) * dir
			print(distance_icba_calculating)
	move_and_slide()
"""
#HAHAHAHAH WATCH ME DO THIS SAME EXACT THING EXCEPT THERE'S NO FUCKING CURVES AND DELTA AND FLOATS AHAHAHAHAHA
func _physics_process(delta):
	player_location = get_parent().get_node("Player").position
	#crow is bugged because player can go farther than its max range and cause it to do multiple cycles
	#this can be fixed if the crow just follows player at all time
	if (player_location.x - position.x) * dir > (150) and (player_location.x - position.x) * dir < (1600) and player_location.y - position.y > 100 and player_location.y - position.y < 1000 and (not flying) and $FlightCooldown.is_stopped():
		#print("flying")
		flying = true
		old_x = position.x
		old_y = position.y
		player_distance = player_location.y
		#print((2 * distance_icba_calculating))
	if ((position.x - old_x) * dir > 1500) and $FlightCooldown.is_stopped():
		#print(position.y)
		flying = false
		velocity.y = -500 
		velocity.x = 0
		if abs(position.y - old_y) < 10:
			$FlightCooldown.start()
			dir *= -1
			apply_scale(Vector2(-1,1))
			velocity.y = 0
			velocity.x = 0
		else:
			rotate += 90 * player_distance/500 * delta
	if flying:
		#print("flying logic")
		#print(rotate)
		velocity = Vector2(500 * dir, 0) if abs(position.y - player_distance) < 10 else Vector2(0, 500)
		
	move_and_slide()
	
func _on_death_timer_timeout():
	queue_free()

func _on_change_direction_timeout():
	apply_scale(Vector2(-1,1))
	dir *= -1

