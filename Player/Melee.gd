extends Area2D

var damage = 0
var sprite 
@export var mana_mult = 100

"""
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play()
"""
	
func setParams(atks : float, dmg : float, reach : float, special : bool):
	damage = dmg
	if special:
		sprite = $AnimatedSprite2D2
		$AnimatedSprite2D.hide()
		$AttackTimer.wait_time = (1.2/atks)
		sprite.speed_scale = (atks/1.2)
		$CollisionPolygon2D.disabled = true
		$CollisionPolygon2D2.disabled = false
		
	else:
		sprite = $AnimatedSprite2D
		$AnimatedSprite2D2.hide()
		$AttackTimer.wait_time = (1.0/atks)
		sprite.speed_scale = atks
		$CollisionPolygon2D2.disabled = true
		$CollisionPolygon2D.disabled = false
	sprite.show()
	sprite.scale.x = sprite.scale.x * reach
	

func _on_attack_timer_timeout():
	queue_free()

func _getDamage():
	return damage
