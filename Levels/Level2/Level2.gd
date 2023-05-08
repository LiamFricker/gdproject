extends Node2D

@export var level_complete : bool = false
@export var levelnum = 2

func _on_level_end_body_entered(_body):
	level_complete = true
	
func _ready():
	$Player.set_abilities(true, false, false)
	
func getLevel():
	return levelnum
