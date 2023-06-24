extends CanvasLayer

#signal intro
#signal walls
#signal down
#signal charge
#signal challenge
#signal basics
#signal finale
#signal boss

func enable() -> void:
	$Title.show()
	$Title.enable()

func disable() -> void:
	$Title.hide()
	$LevelSelect.hide()
	$Title.disable()
	$LevelSelect.disable()

func _on_level_select_pressed() -> void:
	$Title.hide()
	$LevelSelect.show()
	$Title.disable()
	$LevelSelect.enable()

func _on_intro_pressed():
	$LevelSelect.disable()
	$LevelSelect.hide()
	get_parent()._title_screen_start(1)

func _on_walls_pressed():
	$LevelSelect.disable()
	$LevelSelect.hide()
	get_parent()._title_screen_start(2)

func _on_down_pressed():
	$LevelSelect.disable()
	$LevelSelect.hide()
	get_parent()._title_screen_start(3)

func _on_charge_pressed():
	$LevelSelect.disable()	
	$LevelSelect.hide()
	get_parent()._title_screen_start(4)

func _on_challenge_pressed():
	$LevelSelect.disable()
	$LevelSelect.hide()
	get_parent()._title_screen_start(5)

func _on_basics_pressed():
	$LevelSelect.disable()
	$LevelSelect.hide()
	get_parent()._title_screen_start(6)

func _on_finale_pressed():
	$LevelSelect.disable()
	$LevelSelect.hide()
	get_parent()._title_screen_start(7)

func _on_boss_pressed():
	$LevelSelect.disable()
	$LevelSelect.hide()
	get_parent()._title_screen_start(8)
