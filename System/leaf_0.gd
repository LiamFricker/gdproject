extends Node2D

var distance = Vector2(0,0)
var speed = 0 
var mana_amount = 0
"""
func _ready():
	print("created")
"""
func _process(delta) -> void:
	distance = get_parent().get_parent().get_node("Player").position - position
	speed += 300 * delta
	position.x += delta * speed * distance.x/distance.length()
	position.y += delta * speed * distance.y/distance.length()

func _on_area_2d_body_entered(body):
	body.mana += mana_amount
	#print("leaf collected")
	queue_free()
