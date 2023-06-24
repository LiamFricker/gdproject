extends RigidBody2D

var damage = 0
#var rotate = 0
var speed = 0
#var facing_direction = 0 
#var flying = true

@export var mana_mult = 1

"""
func _ready():
	#if flying:
	linear_velocity.x = (600 * facing_direction + speed) * cos(deg_to_rad(rotate)) 
	linear_velocity.y = (600 * facing_direction + speed) * sin(deg_to_rad(rotate))
"""
	
func setParams(dmg : float, rot : float, spd : float, direction : float):
	damage = dmg
	#rotate = rot
	$Node2D.rotation = deg_to_rad(rot)
	$CollisionPolygon2D.rotation = deg_to_rad(rot)
	#$Sprite2D.rotation = deg_to_rad(180+rot)
	#$Area2D.rotation = deg_to_rad(rot)
	speed = spd 
	#facing_direction = direction
	$Node2D.apply_scale(Vector2(direction, 1))
	$CollisionPolygon2D.apply_scale(Vector2(direction, 1))
	$CollisionPolygon2D.position.x = cos(deg_to_rad(rot)) * direction*24
	$CollisionPolygon2D.position.y = sin(deg_to_rad(rot)) * direction*24		
	#$Sprite2D.apply_scale(Vector2(direction, 1))
	#$Area2D.apply_scale(Vector2(direction, 1))
	position.x = 10 * direction
	linear_velocity.x = (600 * direction + speed) * cos(deg_to_rad(rot)) 
	linear_velocity.y = (600 * direction) * sin(deg_to_rad(rot))

func _getDamage():
	return damage

func _on_area_2d_body_entered(body):
	#flying = false
	linear_velocity.x = 0
	linear_velocity.y = 0
	if body is CharacterBody2D:
		$Lifetime.wait_time = 0.05
	$Lifetime.start()

func _on_lifetime_timeout():
	queue_free()


