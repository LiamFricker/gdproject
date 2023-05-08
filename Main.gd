extends Node

#@export var TitleScreen: PackedScene
@export var level0: PackedScene
@export var level1: PackedScene
@export var level2: PackedScene
@export var level3: PackedScene
@export var level4: PackedScene
@export var level5: PackedScene

var test = true
var level
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		swap_fullscreen_mode()

func swap_fullscreen_mode():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _physics_process(_delta: float) -> void:
	if level.level_complete:
		match level.getLevel(): 
			0: 
				level.queue_free()
				level = level1.instantiate()
				add_child(level)
			1:
				level.queue_free()
				level = level2.instantiate()
				add_child(level)
			2:
				level.queue_free()
				level = level3.instantiate()
				add_child(level)
			3:
				level.queue_free()
				level = level4.instantiate()
				add_child(level)
			4:
				level.queue_free()
				level = level5.instantiate()
				add_child(level)
			5: 
				level.queue_free()
				level = level0.instantiate()
				add_child(level)
			

func _ready():
	level = level0.instantiate()
	if test:
		$TitleScreen.hide()
		$TitleScreen.disable()
		add_child(level)
func _on_title_screen_intro():
	$TitleScreen.hide()
	level = level1.instantiate()
	add_child(level)

func _on_title_screen_charge():
	$TitleScreen.hide()
	level = level4.instantiate()
	add_child(level)
	
func _on_title_screen_down():
	$TitleScreen.hide()
	level = level3.instantiate()
	add_child(level)

func _on_title_screen_walls():
	$TitleScreen.hide()
	level = level2.instantiate()
	add_child(level)

func _on_title_screen_final():
	$TitleScreen.hide()
	level = level5.instantiate()
	add_child(level)
