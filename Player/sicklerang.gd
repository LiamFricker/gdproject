extends RigidBody2D

var damage = 0
var speed = 0
var facing_direction = 0 
var turning = false
var rotate = 0
var spin = 0

@export var mana_mult = 1.5

"""
func _ready():
	print("knife created")
"""

func _process(delta):
	
	"""
	if rotate >= 180:
		turning = false
		rotate = 180
	elif turning == true:
		rotate += 1.5	
	$Node2D/Sprite2D.rotation = deg_to_rad(spin)	
	linear_velocity.x = (500 * facing_direction + 0.25*speed) * cos(deg_to_rad(rotate))
	linear_velocity.y = (500 * -1) * sin(deg_to_rad(rotate)) 
	spin += 4
	"""
	if rotate >= 180:
		turning = false
		rotate = 180
	elif turning == true:
		rotate += 1.5 * 240 * delta	#(1.5*60)
		#rotate += 1.5
	$Node2D/Sprite2D.rotation = deg_to_rad(spin)	
	linear_velocity.x = (500 * facing_direction + 0.25*speed) * cos(deg_to_rad(rotate))
	linear_velocity.y = (500 * -1) * sin(deg_to_rad(rotate)) 
	spin += (4 * 240 * delta) #4*60
	#spin += 4
func setParams(dmg : float, spd : float, direction : float):
	damage = 1.5*dmg
	speed = spd 
	facing_direction = direction
	$Node2D.apply_scale(Vector2(direction, 1))
	$CollisionPolygon2D.apply_scale(Vector2(direction, 1))

func _getDamage():
	return damage

func _on_area_2d_body_entered(body):
	#flying = false
	body.sicklerang_return()
	queue_free()

func _on_turn_timer_timeout():
	$Node2D/Area2D.monitoring = true
	turning = true

func _on_lifetime_timeout():
	queue_free()



