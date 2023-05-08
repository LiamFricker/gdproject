extends Node2D

signal bounce
# Called when the node enters the scene tree for the first time.

func _on_area_2d_body_entered(_body):
	bounce.emit()
