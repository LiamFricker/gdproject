extends Node2D

var special
@export var fireball: PackedScene 
@export var bone: PackedScene
@export var bomb: PackedScene
@export var egg: PackedScene
@export var enemy: PackedScene
var bullet

var entity_number = 0

var leaf
@export var leaf0: PackedScene
var absolute_mana = 0
var leaf_rng

var gold
@export var gold0: PackedScene

func special_cast(special_used : PackedScene, player_position : Vector2, dmg : float, speed : float, direction : float):
	special = special_used.instantiate()
	special.setParams(dmg, speed, direction)
	add_child(special)
	special.position = player_position

func collect_mana(moyaipos : Vector2, dmg : float) -> void:
	leaf_rng = RandomNumberGenerator.new()
	absolute_mana = dmg / get_parent().get_node("Player").attack_dmg
	#print(absolute_mana)
	leaf = leaf0.instantiate()
	leaf.position = moyaipos
	if absolute_mana >= (3):
		create_leaf(moyaipos, ceilf(absolute_mana/4 * (1.5 + get_parent().get_node("Player").max_mana / 50)))
		create_leaf(moyaipos, ceilf(absolute_mana/4 * (1.5 + get_parent().get_node("Player").max_mana / 50)))
		create_leaf(moyaipos, ceilf(absolute_mana/4 * (1.5 + get_parent().get_node("Player").max_mana / 50)))
	elif absolute_mana >= (2):
		create_leaf(moyaipos, ceilf(absolute_mana/3 * (1.5 + get_parent().get_node("Player").max_mana / 50)))
		create_leaf(moyaipos, ceilf(absolute_mana/3 * (1.5 + get_parent().get_node("Player").max_mana / 50)))
	else:
		create_leaf(moyaipos, ceilf(absolute_mana * (1.5 + get_parent().get_node("Player").max_mana / 50)))

func create_leaf(moyaipos : Vector2, mana_am : float) -> void:
	leaf = leaf0.instantiate()
	leaf.position = moyaipos
	leaf.mana_amount = mana_am
	leaf.position.x += leaf_rng.randi_range(-10, 10)
	leaf.position.y += leaf_rng.randi_range(-10, 10)
	leaf.rotation += leaf_rng.randi_range(-180, 180) 
	call_deferred("add_child", leaf)
	
func create_gold(moyaipos : Vector2, gold_am : float) -> void:	
	gold = gold0.instantiate()
	gold.position = moyaipos
	gold.gold = gold_am
	call_deferred("add_child", gold)
	
func create_bullet(moyaipos : Vector2, dmg : float, direction : float, bullet_num : float) -> void:
	#replace this with a switch case later ~ ~ ~
	if bullet_num == 1:
		bullet = fireball.instantiate()
	elif bullet_num == 2:
		bullet = bone.instantiate()
	elif bullet_num == 3:
		bullet = bomb.instantiate()
	elif bullet_num == 4:
		entity_number += 1
		bullet = egg.instantiate() if entity_number < 6 else bomb.instantiate()
	"""
	elif bullet_num == 5:
		bullet = enemy.instantiate()
		bullet.is_egg = true
		bullet.face_direction = direction
		bullet.position = moyaipos
		call_deferred("add_child", bullet)
		return
		#enemy.apply_scale(Vector2(dir, 1))
		add_child(bullet)
	"""	
	bullet.setParams(dmg, direction)
	bullet.position = moyaipos
	call_deferred("add_child", bullet)
