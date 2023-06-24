extends RigidBody2D

var damage = 0
var sprite 
var flame_number = 0
var facing_direction = 1
@export var flame: PackedScene

var flames# = [null, null, null]

@export var mana_mult = 1.5

func setParams(dmg : float, speed : float, direction : float):	
	linear_velocity.x = ((250 * direction) + speed*0.5 if abs(speed) < 800 else (250 * direction) + speed) if direction == sign(speed) else (250 * direction)
	damage = dmg
	facing_direction = direction
	
func _on_area_2d_body_entered(_body):
	#$CollisionPolygon2D.set_deferred("disabled", true)
	$Area2D.set_deferred("monitoring", false)
	$AnimationPlayer.play("Break")
	linear_velocity.x = 0
	linear_velocity.y = 0
	gravity_scale = 0

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Break":
		create_flame()

func create_flame() -> void:
	#flames[flame_number] = flame.instantiate()
	flames = flame.instantiate()
	flames.setParams(damage, flame_number) if facing_direction != -1 else flames.setParams(damage, -1*(flame_number+1.2)) 
	flame_number += 1
	$FlameTimer.start()
	add_child(flames)

func _on_flame_timer_timeout():
	$Break.visible = false
	set_collision_layer_value(6,  false)
	if flame_number < 3:
		create_flame()
	else:
		$Lifetime.start()
		$FlameTimer.stop()
	
func _on_lifetime_timeout():
	queue_free()
	
func _getDamage():
	return damage / 2

