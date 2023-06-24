extends Node2D

@onready var Animator := $AnimationPlayer
@onready var Animator2 := $AnimationPlayer2

#func _playAttack() -> void:
#	Animator.play("Hit")
func _playHurt() -> void:
	Animator2.play("Hit")
func _playDeath() -> void:	
	Animator.play("Death")

func _stop() -> void:
	Animator.stop()
	
func _reset() -> void:
	Animator.play("RESET")
