extends "res://Mobs/square.gd"

enum  {
	IDLE,
	WALKING,
	RUNNING,
	ATTACKING
}

@export var walk_speed: float = 100
var state = IDLE
@export var face_direction = 1
@export var detection_range: float = 1200
var start = true
var distance = 0
var old_position = 0 

func _process(_delta):
	if health > 0 and pow(pow(abs(get_parent().get_node("Player").position.x - position.x), 2) + pow(abs(get_parent().get_node("Player").position.y - position.y), 2), 0.5) < detection_range:
		velocity.x = face_direction * walk_speed 

