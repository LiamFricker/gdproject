extends Node2D

signal slopeR

func _on_area_2d_body_entered(_area):
	slopeR.emit()
