extends Node2D

#@export var brick_id = 0

signal blockbreak
# Called when the node enters the scene tree for the first time.
#func ready():
#	add_to_group("bricks")

#func _on_area_2d_body_entered(_body):
#	blockbreak.emit(get_path())

func _on_area_2d_area_entered(_area):
	blockbreak.emit(get_path())

func destroy() -> void:
	#animation
	queue_free()


