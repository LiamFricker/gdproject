extends CharacterBody2D

@export var health: float = 50
@export var dmg: float = 1
@export var gravity: float = 1020
@export var dir : float = 1
@export var bullet : float = 2

@export var cooldown : float = 2.75
var direction = 1

@export var bone_distance : float = 1

#@export var fireball: PackedScene 

#var bullet

#Some possible issues may occur if Moyai is moved while the fireball is moved. Maybe make fireball a  function of world?

#var shooting = false

func _ready():
	$ShootingCooldown.wait_time = cooldown
	$DetectionRange/CollisionPolygon2D.position.x = 206 * bone_distance 

func _on_detection_range_body_entered(_body):
	#$ShootingTimer.start()
	$ShootingCooldown.start()
	$DetectionRange.position.y += 10000
	$Sprite/AnimationPlayer.play("Attack")
	$IdleTimer.start()
	$ShootingTimer.start()
	velocity.x = 0
	
func _on_shooting_timer_timeout():
	get_parent().get_node("AbilitySpawner").create_bullet(Vector2(position.x -10 + dir * 40, position.y - 37.5), dmg, dir  * bone_distance , bullet)	
	#bullet = fireball.instantiate()
	#bullet.setParams(dmg, scale.x)
	#add_child(bullet)

func _on_shooting_cooldown_timeout():
	$DetectionRange.position.y -= 10000


func _on_hurtbox_area_entered(area):
	if $DeathTimer.is_stopped():
		health -= area._getDamage()
		if health > 0:
			#$Sprite._playHurt()
			$Sprite/AnimationPlayer2.play("Hit")
		else:
			#$Sprite._playDeath()
			#$PhysicsHitbox.disabled
			$Sprite/AnimationPlayer.play("Death")
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
			$Sprite/AnimationPlayer.play("Death")
			$Hitbox.set_deferred("monitorable", false)
			$DeathTimer.start()

func idling():
	direction *=  -1
	$IdleTimer.start()
	#jumping = false
	velocity.x = 50 * direction
	velocity.y = -200

func _physics_process(delta):
	if $ChangeDirection.is_stopped() and (get_parent().get_node("Player").position.x - position.x) * dir < (-10):
		$ChangeDirection.start()
	# Add the gravity.
	if not is_on_floor(): #and jumping == false:
		velocity.y += gravity * delta
	if not $Sprite/AnimationPlayer.is_playing() and $IdleTimer.is_stopped() and is_on_floor(): 
		idling()
	move_and_slide()

func _on_death_timer_timeout():
	queue_free()

func _on_jump_timer_timeout():
	velocity.x = 0

func _on_change_direction_timeout():
	apply_scale(Vector2(-1,1))
	dir *= -1
