extends CanvasLayer


func enable() -> void:
	$Intro.disabled = false
	$Walls.disabled = false
	$Down.disabled = false
	$Charge.disabled = false
	$Challenge.disabled = false
	$Basics.disabled = false
	$Finale.disabled = false
	$Boss.disabled = false
	
func disable() -> void:
	$Intro.disabled = true
	$Walls.disabled = true
	$Down.disabled = true
	$Charge.disabled = true
	$Challenge.disabled = true
	$Basics.disabled = true
	$Finale.disabled = true
	$Boss.disabled = true
