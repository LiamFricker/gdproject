extends RigidBody2D

#@export var gold: float = 1
var gold = 1

func _on_area_2d_body_entered(body):
	#get_parent().get_parent().money += gold
	body.money += gold
	queue_free()

func _on_expiration_timeout():
	$AnimationPlayer.play("Blinking")

func _on_animation_player_animation_finished(_anim_name):
	queue_free()
