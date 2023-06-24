extends CharacterBody2D

@export var health: float = 10000
@export var dmg: float = 1
@export var gravity: float = 1020

var is_egg = false

func _on_hurtbox_area_entered(area):
	#if $DeathTimer.is_stopped():
	get_parent().get_node("AbilitySpawner").collect_mana(position, 4 * area.mana_mult * area._getDamage())
		#health -= area._getDamage()
	#	if health > 0:
			#$Sprite._playHurt()
	$Sprite/AnimationPlayer2.play("Hit")

func _on_hurtbox_body_entered(body):
	get_parent().get_node("AbilitySpawner").collect_mana(position, 4 * body.mana_mult * body._getDamage()) 
	#$Sprite._playHurt()
	$Sprite/AnimationPlayer2.play("Hit")
			
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
