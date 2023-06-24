extends CharacterBody2D

@export var health: float = 50
@export var dmg: float = 1
@export var gravity: float = 1020
@export var dir : float = 1

@export var bullet : float = 1

#@export var fireball: PackedScene 

#var bullet

#Some possible issues may occur if Moyai is moved while the fireball is moved. Maybe make fireball a  function of world?

#var shooting = false

func _on_detection_range_body_entered(_body):
	#$ShootingTimer.start()
	$ShootingCooldown.start()
	$DetectionRange.position.y += 10000
	$Sprite/AnimatedSprite2D.play("Shoot")
	get_parent().get_node("AbilitySpawner").create_bullet(Vector2(position.x - ((1-bullet) *30) * dir, position.y + bullet * 10), dmg, dir, bullet)
	
#func _on_shooting_timer_timeout():
	
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
			$Sprite/AnimatedSprite2D.visible = false
			$Sprite/AnimatedSprite2D2.visible = true
			$Sprite/AnimatedSprite2D2.play("Death")
			set_collision_layer_value(3,  false)
			set_collision_layer_value(4,  false)
			$ShootingCooldown.start()
			gravity = 0
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
			set_collision_layer_value(3,  false)
			set_collision_layer_value(4,  false)
			$ShootingCooldown.start()
			gravity = 0
			$DeathTimer.start()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func _on_death_timer_timeout():
	queue_free()

