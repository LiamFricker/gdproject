extends Node2D

@export var level_complete : bool = false
@export var levelnum = 5

func _on_level_end_body_entered(_body):
	level_complete = true

func _ready():
	$Player.set_abilities(true, true, true)

func getLevel():
	return levelnum
