extends CanvasLayer

signal intro
signal walls
signal down
signal charge
signal final

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
	intro.emit()

func _on_walls_pressed():
	$LevelSelect.disable()
	$LevelSelect.hide()
	walls.emit()

func _on_down_pressed():
	$LevelSelect.disable()
	$LevelSelect.hide()
	down.emit()

func _on_charge_pressed():
	$LevelSelect.disable()	
	$LevelSelect.hide()
	charge.emit()

func _on_final_pressed():
	$LevelSelect.disable()
	$LevelSelect.hide()
	final.emit()
