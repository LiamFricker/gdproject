extends RigidBody2D

var dmg = 1

func setParams(damage : float, direction : float):
	#print(direction)
	$Node2D.apply_scale(Vector2(direction,1))
	$Hurtbox.apply_scale(Vector2(direction,1))
	linear_velocity.x = linear_velocity.x * direction
	dmg = damage
	
func _on_hurtbox_area_entered(_area):
	queue_free()

func _on_hurtbox_body_entered(_body):
	queue_free()

func _on_timer_timeout():
	queue_free()
"""	
func _on_death_timer_timeout():
	queue_free()
"""
