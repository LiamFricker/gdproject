extends Node2D

@export var level_complete : bool = false



func _ready():
	$Player.set_abilities(true, true, true)

## Switching between fullscreen and not fullscreen by pressing esc
"""
func _ready():
	var bricks = get_tree().get_nodes_in_group("bricks")
	for brick in bricks:
		brick.connect("brickbreak", self, destroy_brick)
		
func destroy_brick(brickid):
	if $Player.downairing:
		pass
		
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		swap_fullscreen_mode()

func swap_fullscreen_mode():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
"""
