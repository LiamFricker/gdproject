extends Node2D

#@export var brick_id = 0

signal brickbreak
# Called when the node enters the scene tree for the first time.
#func ready():
#	add_to_group("bricks")

func _on_area_2d_body_entered(_body):
	brickbreak.emit(get_path())

func destroy() -> void:
	#animation
	queue_free()
