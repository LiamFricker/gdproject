extends CharacterBody2D

@export var health: float = 50
@export var dmg: float = 1
@export var gravity: float = 1020
@export var dir : float = 1
#var delayed_dir = dir
@export var bullet : float = 1

@export var ambush_height : float = 200
@export var jump_height : float = 200
var waiting = true

@export var cooldown : float = 3.75
var direction = 1
@onready var upwards_velocity = -1 * jump_height * 12

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
	get_parent().get_node("AbilitySpawner").create_bullet(Vector2(position.x -10 + dir * 20, position.y - 20), dmg, dir, bullet)	
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

func _physics_process(delta):
	if $ChangeDirection.is_stopped() and (get_parent().get_node("Player").position.x - position.x) * dir < (-10):
		$ChangeDirection.start()
		#delayed_dir *= -1
	if not $JumpTimer.is_stopped():
		velocity.y = upwards_velocity  
		velocity.y -= 9.8
	if not is_on_floor() and not waiting: #and jumping == false:
		velocity.y += gravity * delta
	move_and_slide()

func _on_death_timer_timeout():
	queue_free()

func _on_change_direction_timeout():
	apply_scale(Vector2(-1,1))
	dir *= -1

