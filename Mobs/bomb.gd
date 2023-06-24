extends RigidBody2D

var dmg = 1 
var health = 5

#var spin = 0
var floored = false

@export var flame: PackedScene
var flames
"""
func _process(_delta):
	$Sprite2D.rotation = deg_to_rad(spin)
	$Hurtbox.rotation = deg_to_rad(spin)
	spin += 2
"""
	
func setParams(damage : float, direction : float):
	#print(direction)
	$Sprite2D.apply_scale(Vector2(sign(direction),1))
	#$Hurtbox.apply_scale(Vector2(direction,1))
	linear_velocity.x = linear_velocity.x * direction
	dmg = damage

func _on_collision_body_entered(_body):
	floored = true
	linear_velocity.x = 0
	linear_velocity.y = 0
	gravity_scale = 0
	$ExplosionTimer.start()
	$Collision.set_deferred("monitoring", false)
		
func _on_explosion_timer_timeout():
	$AnimatedSprite2D.play("explode")
	$Sprite2D.visible = false
	$Hurtbox.monitorable = false
	
func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.visible = false
	flames = flame.instantiate()
	flames.setParams(dmg)
	add_child(flames)
	
func _on_hurtbox_area_entered(area):
	health -= area._getDamage()
	if health <= 0:
		queue_free()

func _on_hurtbox_body_entered(body):
	health -= body._getDamage()
	if health <= 0:
		queue_free()

func _on_lifetime_timeout():
	queue_free()




