extends Node

#@export var TitleScreen: PackedScene
@export var level0: PackedScene
@export var level1: PackedScene
@export var level2: PackedScene
@export var level3: PackedScene
@export var level4: PackedScene
@export var level5: PackedScene
@export var levela_1: PackedScene
@export var levela_2: PackedScene
@export var levela_3: PackedScene

#var test = false
var test = true
var level
var level_num = 0
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		swap_fullscreen_mode()

func swap_fullscreen_mode():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

#func _physics_process(_delta: float) -> void:


		
			
func _level_complete():
	#if level.level_complete:
		match level.getLevel(): 
			0: 
				level.queue_free()
				level = level1.instantiate()
				level_num = 1
				add_child(level)
			1:
				level.queue_free()
				level = level2.instantiate()
				level_num = 2
				add_child(level)
			2:
				level.queue_free()
				level = level3.instantiate()
				level_num = 3
				add_child(level)
			3:
				level.queue_free()
				level = level4.instantiate()
				level_num = 4
				add_child(level)
			4:
				level.queue_free()
				level = level5.instantiate()
				level_num = 5
				add_child(level)
			5: 
				level.queue_free()
				level = levela_1.instantiate()
				level_num = 6
				add_child(level)
			6:
				level.queue_free()
				level = levela_2.instantiate()
				level_num = 7
				add_child(level)	
			7: 		
				level.queue_free()
				level = levela_3.instantiate()
				level_num = 8
				add_child(level)
			8: 		
				level.queue_free()
				level = level0.instantiate()
				level_num = 0
				add_child(level)

func _ready():
	$GameOverScreen.hide()
	$GameOverScreen.disable()
	level = level0.instantiate()
	if test:
		$TitleScreen.hide()
		$TitleScreen.disable()
		level_num = 0
		add_child(level)
"""
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
"""		

func _title_screen_start(levelnum : int):
	$TitleScreen.hide()
	match levelnum: 
			0: 
				level = level0.instantiate()
				level_num = 0
			1:
				level = level1.instantiate()
				level_num = 1
			2:
				level = level2.instantiate()
				level_num = 2
			3:
				level = level3.instantiate()
				level_num = 3
			4:
				level = level4.instantiate()
				level_num = 4
			5: 
				level = level5.instantiate()
				level_num = 5
			6:
				level = levela_1.instantiate()
				level_num = 6
			7:
				level = levela_2.instantiate()
				level_num = 7
			8:
				level = levela_3.instantiate()
				level_num = 8
	add_child(level)			
	
func game_over():
	level.queue_free()
	$GameOverScreen.show()
	$GameOverScreen.enable()
	
func _on_game_over_screen_continue_game():
	$GameOverScreen.hide()
	match level_num: 
			0: 
				level = level0.instantiate()
			1:
				level = level1.instantiate()
			2:
				level = level2.instantiate()
			3:
				level = level3.instantiate()
			4:
				level = level4.instantiate()
			5: 
				level = level5.instantiate()
			6:
				level = levela_1.instantiate()
			7:
				level = levela_2.instantiate()
			8:
				level = levela_3.instantiate()
	add_child(level)

func _on_game_over_screen_main_menu():
	$GameOverScreen.hide()
	$TitleScreen.show()
	$TitleScreen.enable()
