extends Node2D

var damage = 0
var speed =0
var flame_number = 0
var facing_direction = 1
@export var knife: PackedScene

var knives = [null, null, null]

func _ready():
	knives[0] = knife.instantiate()
	knives[1] = knife.instantiate()
	knives[2] = knife.instantiate()
	knives[0].setParams(damage, 0, speed, facing_direction)
	knives[1].setParams(damage, 30, speed, facing_direction)
	knives[2].setParams(damage, -30, speed, facing_direction)
	#if facing_direction == -1:
	#	knives[0].scale.x *= -1
	#	knives[1].scale.x *= -1
	#	knives[2].scale.x *= -1
	add_child(knives[0])
	add_child(knives[1])
	add_child(knives[2])

func setParams(dmg : float, spd : float, direction : float):	
	damage = dmg
	speed = spd
	facing_direction = direction

"""
func create_knives():
	return knife.instantiate()
"""

func _on_lifetime_timeout():
	queue_free()
	
#Placeholder, never used
func _getDamage():
	return 0

