extends Node2D

@export var level_complete : bool = false
@export var levelnum = 1

func _on_level_end_body_entered(_body):
	get_parent()._level_complete()

func _ready():
	$Player.set_abilities(false, false, false)

func special_rotate() -> void:
	$HUD._on_button_button_down()

func _process(_delta):
	$HUD.DashCool = $Player.get_dashcooldown()
	$HUD._lockedDashCharge()

func getLevel():
	return levelnum
