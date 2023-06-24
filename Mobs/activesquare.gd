extends "res://Mobs/square.gd"

enum  {
	IDLE,
	WALKING,
	RUNNING,
	ATTACKING
}

@export var walk_speed: float = 150
@export var run_speed: float = 300
var state = IDLE
@export var face_direction = 1
var start = true
var distance = 0
var old_position = 0 

func _process(_delta):
	if health > 0:
		match state:
			IDLE:
				idling()
			WALKING:
				walking()
			RUNNING:
				running()
			ATTACKING:
				attacking()

func idling() -> void:
	velocity.x = 0
	if start:
		$IdleTimer.start()
		$Sprite/AnimationPlayer.play("Idle")
		start = false

func _on_idle_timer_timeout():
	if state == IDLE: 	
		state = WALKING
		$Sprite/AnimationPlayer.play("RESET")
	start = true


func walking() -> void:
	if start:
		flip_direction()
		$WalkTimer.start()
		start = false
	velocity.x = face_direction * walk_speed #* delta 

func _on_walk_timer_timeout():
	if state == WALKING: 	
		state = IDLE
	start = true

func _on_detection_range_body_entered(body):
	#print(body.position.x)
	#print(position.x)
	if state != ATTACKING:
		state = RUNNING
		set_direction(sign(get_parent().position.x + position.x - body.position.x) * -1)
		distance = abs(get_parent().position.x + position.x - body.position.x) if is_egg else abs(position.x - body.position.x)
		old_position = position.x 
	

func running() -> void:
	#print(distance)
	velocity.x = face_direction * run_speed #* delta 
	if (distance - abs(position.x - old_position)) < 75:
		state = ATTACKING 
		start = true
		
func attacking() -> void:
	velocity.x = 0
	if start:
		$Sprite/AnimationPlayer.play("Attack")
		$AttackTimer.start()
		start = false

func _on_attack_timer_timeout():
	state = IDLE
	start = true


func flip_direction() -> void:

	face_direction *= -1
	apply_scale(Vector2(-1, 1))

func set_direction(hor_direction) -> void:
	if hor_direction == 0:
		return
	apply_scale(Vector2(hor_direction * face_direction, 1))
	face_direction = hor_direction
