extends CanvasLayer

signal continue_game
signal main_menu

func disable() -> void:
	$Title.visible = false
	$Title/Continue.disabled = true
	$Title/MainMenu.disabled = true

func enable() -> void:
	$Title.visible = true
	$Title/Continue.disabled = false
	$Title/MainMenu.disabled = false

func _on_continue_pressed():
	disable()
	continue_game.emit()

func _on_main_menu_pressed():
	disable()
	main_menu.emit()
