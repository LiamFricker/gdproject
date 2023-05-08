extends CanvasLayer


func enable() -> void:
	$Level_Select.disabled = false
	
func disable() -> void:
	$Level_Select.disabled = true
