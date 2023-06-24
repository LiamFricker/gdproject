extends Area2D

var damage = 0
var flame_distance = 36

@export var mana_mult = 0.1

"""
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play()
"""

#Switch Flametick to 1.2s for 3 ticks, 1.5s for 2 ticks
	
func setParams(dmg : float, flame_number : float):
	damage = dmg
	position.x = 16 + (flame_distance * flame_number)

func _on_flametick_timeout():
	$FlameRetick.start()
	$CollisionPolygon2D.position.y += 10000
	
func _on_flame_retick_timeout():
	$CollisionPolygon2D.position.y -= 10000
	$Flametick.start()

func _getDamage():
	return damage

func _on_lifetime_timeout():
	queue_free()


