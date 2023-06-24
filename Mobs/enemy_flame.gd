extends Area2D

var dmg = 0
var flame_distance = 36

#Switch Flametick to 1.2s for 3 ticks, 1.5s for 2 ticks
	
func setParams(damage : float):
	dmg = damage
	
func _on_flametick_timeout():
	$FlameRetick.start()
	$CollisionPolygon2D.position.y += 10000
	
func _on_flame_retick_timeout():
	$CollisionPolygon2D.position.y -= 10000
	$Flametick.start()

"""
func _getDamage():
	return damage
"""

func _on_lifetime_timeout():
	queue_free()


