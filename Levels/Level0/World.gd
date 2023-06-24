extends Node2D

@export var level_complete : bool = false
"""
var special
@export var fireball: PackedScene 
@export var bone: PackedScene
var bullet
"""

func _ready():
	$Player.set_abilities(false, false, false)
	#Player.set_abilities(true, true, true)
func _process(delta):
	$HUD.DashCool = $Player.get_dashcooldown()
	$HUD.DashChar = $Player.get_dashcharge()
	$HUD.health = $square2.health
	#$HUD.health = 1/delta
## Switching between fullscreen and not fullscreen by pressing esc
"""
func special_cast(special_used : PackedScene, player_position : Vector2, dmg : float, speed : float, direction : float):
	special = special_used.instantiate()
	special.setParams(dmg, speed, direction)
	add_child(special)
	special.position = player_position

func create_bullet(moyaipos : Vector2, dmg : float, direction : float, bullet_num : float) -> void:
	if bullet_num == 1:
		bullet = fireball.instantiate()
	elif bullet_num == 2:
		bullet = bone.instantiate()
	bullet.setParams(dmg, direction)
	bullet.position = moyaipos
	call_deferred("add_child", bullet)
"""

func special_rotate() -> void:
	$HUD._on_button_button_down()
	

	
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
