extends CharacterBody2D

@export var health: float = 1
@export var dmg: float = 1
@export var gravity: float = 1020

var is_egg = false

func _on_hurtbox_area_entered(area):
	if $DeathTimer.is_stopped():
		get_parent().get_node("AbilitySpawner").collect_mana(position, area.mana_mult * area._getDamage()) if not is_egg else get_parent().get_parent().get_parent().get_node("AbilitySpawner").collect_mana(get_parent().position + position, area.mana_mult * area._getDamage())
		health -= area._getDamage()
		if health > 0:
			#$Sprite._playHurt()
			$Sprite/AnimationPlayer2.play("Hit")
		else:
			#$Sprite._playDeath()
			get_parent().get_node("AbilitySpawner").create_gold(position, 1) if not is_egg else get_parent().get_parent().get_parent().get_node("AbilitySpawner").create_gold(position, 1)
			$Sprite/AnimationPlayer.play("Death")
			$Hitbox.set_deferred("monitorable", false)
			$DeathTimer.start()


func _on_hurtbox_body_entered(body):
	if $DeathTimer.is_stopped():
		get_parent().get_node("AbilitySpawner").collect_mana(position, body.mana_mult * body._getDamage()) if not is_egg else get_parent().get_parent().get_parent().get_node("AbilitySpawner").collect_mana(get_parent().position + position, body.mana_mult * body._getDamage())
		health -= body._getDamage()
		if health > 0:
			#$Sprite._playHurt()
			$Sprite/AnimationPlayer2.play("Hit")
		else:
			#$Sprite._playDeath()
			get_parent().get_node("AbilitySpawner").create_gold(position, 1) if not is_egg else get_parent().get_parent().get_parent().get_node("AbilitySpawner").create_gold(position, 1)
			$Sprite/AnimationPlayer.play("Death")
			$Hitbox.set_deferred("monitorable", false)
			$DeathTimer.start()
			

func _on_timer_timeout():
	if is_egg:
		get_parent()._death()
	queue_free()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
