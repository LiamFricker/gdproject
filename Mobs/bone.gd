extends RigidBody2D

var dmg = 1 

#var turning = true
#var rotate = 0
var spin = 0

"""
func _ready():
	print("bone created")
"""

func _process(delta):
	"""
	if turning == true:
		rotate += 1.5
	if rotate >= 180:
		turning = false
		rotate = 180	
	$Node2D/Sprite2D.rotation = deg_to_rad(spin)	
	linear_velocity.x = (500 * facing_direction) * cos(deg_to_rad(rotate))
	linear_velocity.y = (500 * -1) * sin(deg_to_rad(rotate)) 
	spin += 4
	"""
	$Sprite2D.rotation = deg_to_rad(spin)
	$Hurtbox.rotation = deg_to_rad(spin)
	spin += 2 * 240 * delta
	#spin += 2
func setParams(damage : float, direction : float):
	#print(direction)
	$Sprite2D.apply_scale(Vector2(sign(direction),1))
	$Hurtbox.apply_scale(Vector2(sign(direction),1))
	linear_velocity.x = linear_velocity.x * direction
	dmg = damage
	
func _on_hurtbox_area_entered(_area):
	queue_free()

func _on_hurtbox_body_entered(_body):
	queue_free()

func _on_lifetime_timeout():
	queue_free()
