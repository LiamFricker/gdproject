extends "res://Mobs/Sprite.gd"

#@onready var Animator2 := $AnimationPlayer

func _playAttack() -> void:
	Animator.play("Attack")

func _playIdle() -> void:
	Animator.play("Idle")
"""
func _stop() -> void:
	Animator.stop()
	
func _reset() -> void:
	Animator.play("RESET")
"""
