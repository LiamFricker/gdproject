extends CanvasLayer


func enable() -> void:
	$Intro.disabled = false
	$Walls.disabled = false
	$Down.disabled = false
	$Charge.disabled = false
	$Final.disabled = false
	
func disable() -> void:
	$Intro.disabled = true
	$Walls.disabled = true
	$Down.disabled = true
	$Charge.disabled = true
	$Final.disabled = true
