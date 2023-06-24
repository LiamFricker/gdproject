extends RigidBody2D

var dmg = 1 
var health = 10

#var spin = 0
var floored = false
var start = true
var dir = 1

@export var baby: PackedScene
var enemy

"""
func _process(_delta):
	$Sprite2D.rotation = deg_to_rad(spin)
	$Hurtbox.rotation = deg_to_rad(spin)
	spin += 2
"""
	
func setParams(damage : float, direction : float):
	#print(direction)
	#$Sprite2D.apply_scale(Vector2(direction,1))
	#$Hurtbox.apply_scale(Vector2(direction,1))
	linear_velocity.x = linear_velocity.x * direction
	dir = direction
	dmg = damage

func _on_collision_body_entered(_body):
	floored = true
	linear_velocity.x = 0
	linear_velocity.y = 0
	gravity_scale = 0
	$Collision.set_deferred("monitoring", false)
	$AnimatedSprite2D2.play("default")
		
func _on_animated_sprite_2d_2_animation_finished():
	if start:
		start = false	
		$AnimatedSprite2D2.play("break")
		$AnimationPlayer.play("crack")

func _on_animation_player_animation_finished(_anim_name):
	$Sprite.visible = false
	$Hurtbox.monitoring = false
	#get_parent().create_bullet(Vector2(position.x, position.y), dmg, dir, 5)
	enemy = baby.instantiate()
	enemy.is_egg = true
	#enemy.face_direction = dir
	add_child(enemy)
func _on_hurtbox_area_entered(area):
	health -= area._getDamage()
	if health <= 0:
		$AnimatedSprite2D.play("default")

func _on_hurtbox_body_entered(body):
	health -= body._getDamage()
	if health <= 0:
		$AnimatedSprite2D.play("default")

func _on_animated_sprite_2d_animation_finished():
	_death()

func _death():
	get_parent().entity_number -= 1
	queue_free()
	
func _on_lifetime_timeout():
	_death()

