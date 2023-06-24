extends Area2D

var damage = 0
var sprite 
@export var mana_mult = 1.5
	
func setParams(dmg : float):#, dmg : float, reach : float, special : bool):
	damage = dmg
	
func _getDamage():
	return damage
	
#Add the punch back mechanic later
"""
func _on_area_entered(_area):
	#use raycast if this is buggy
	get_parent().down_air_jump = true
"""
