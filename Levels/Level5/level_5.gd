extends Node2D

@export var level_complete : bool = false
@export var levelnum = 5

func _on_level_end_body_entered(_body):
	get_parent()._level_complete()

func _ready():
	$Player.set_abilities(true, true, true)
	
func _process(_delta):
	$HUD.DashCool = $Player.get_dashcooldown()
	$HUD.DashChar = $Player.get_dashcharge()
	
func special_rotate() -> void:
	$HUD._on_button_button_down()	
	
func getLevel():
	return levelnum
