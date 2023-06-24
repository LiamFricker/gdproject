extends CanvasLayer

@export var DashCool: float = 100
@export var DashChar: float = 0
@export var health: float = 100
var health2 = 0
var int_Cool = 0
var int_Charge = 0
var int_health = 1000

var subweapon = HOLYWATER
var subweapon0 = HOLYWATER

enum {
	HOLYWATER,
	KNIFE, 
	SICKLERANG
}

# Called when the node enters the scene tree for the first time.
"""
func _ready():
	$Control/Button["custom_styles/normal"].bg_color = Color("000000")
	$Control2/Button["custom_styles/normal"].bg_color = Color("000000")
	$Control3/Button["custom_styles/normal"].bg_color = Color("000000")
"""

func _lockedDashCharge():
	$DashCharge.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	int_Cool = int(ceil(DashCool))
	int_Charge = int(ceil(DashChar))
	int_health = int(ceil(health))
	$DashCooldown.text = "Dash Cooldown: " + str(int_Cool) + "%"
	$DashCharge.text = "Dash Charge: " + str(int_Charge) + "%"
	$Health.text = "Health: " + str(health) + "hp"
	$Mana.text = "Mana: " + str(get_parent().get_node("Player").mana)
	if health2 != 0:
		$Health2.text = "Boss Health: " + str(int(ceil(health2))) + "hp"
	$Control3/Subweapon.text = "Healing Pot: " + str(get_parent().get_node("Player").max_mana * 3/10) + " mana"
	$Control3/ColorRect.color = Color8(255,0,0,42) if get_parent().get_node("Player").mana < 30 else Color8(0,0,0,42)
	match subweapon:
		HOLYWATER:
			$Control/Subweapon.text = "Subweapon: Flaming Concoction \n Cooldown: " + str(get_parent().get_node("Player").special_cooldown_timer)
			$Control/TextureRect.visible = true
			$Control/TextureRect2.visible = false
			$Control/TextureRect3.visible = false
			$Control/ColorRect.color = Color8(255,0,0,42) if get_parent().get_node("Player").mana < 30 else Color8(0,0,0,42)
			
		KNIFE:
			$Control/Subweapon.text = "Subweapon: Knife Throw \n Cooldown: " + str(get_parent().get_node("Player").special_cooldown_timer)
			$Control/TextureRect2.visible = true
			$Control/TextureRect.visible = false
			$Control/TextureRect3.visible = false
			$Control/ColorRect.color = Color8(255,0,0,42) if get_parent().get_node("Player").mana < 20 else Color8(0,0,0,42)
		SICKLERANG:
			$Control/Subweapon.text = "Subweapon: Sicklerang \n Cooldown: " + str(get_parent().get_node("Player").special_cooldown_timer)
			$Control/TextureRect3.visible = true
			$Control/TextureRect2.visible = false
			$Control/TextureRect.visible = false
			$Control/ColorRect.color = Color8(255,0,0,42) if get_parent().get_node("Player").mana < 35 else Color8(0,0,0,42)
	match subweapon0:
		HOLYWATER:
			$Control2/Subweapon.text = "Subweapon: Flaming Concoction \n Cooldown: " + str(get_parent().get_node("Player").special_cooldown_timer0)
			$Control2/TextureRect.visible = true
			$Control2/TextureRect2.visible = false
			$Control2/TextureRect3.visible = false
			$Control2/ColorRect.color = Color8(255,0,0,42) if get_parent().get_node("Player").mana < 30 else Color8(0,0,0,42)
			
		KNIFE:
			$Control2/Subweapon.text = "Subweapon: Knife Throw \n Cooldown: " + str(get_parent().get_node("Player").special_cooldown_timer0)
			$Control2/TextureRect2.visible = true
			$Control2/TextureRect.visible = false
			$Control2/TextureRect3.visible = false
			$Control2/ColorRect.color = Color8(255,0,0,42) if get_parent().get_node("Player").mana < 20 else Color8(0,0,0,42)
		SICKLERANG:
			$Control2/Subweapon.text = "Subweapon: Sicklerang \n Cooldown: " + str(get_parent().get_node("Player").special_cooldown_timer0)
			$Control2/TextureRect3.visible = true
			$Control2/TextureRect2.visible = false
			$Control2/TextureRect.visible = false
			$Control2/ColorRect.color = Color8(255,0,0,42) if get_parent().get_node("Player").mana < 35 else Color8(0,0,0,42)
	
	

func _on_button_button_down():
	get_parent().get_node("Player").special_rotate(1)
	subweapon = HOLYWATER if subweapon == SICKLERANG else (KNIFE if subweapon == HOLYWATER else SICKLERANG)

func _on_button2_button_down():
	get_parent().get_node("Player").special_rotate(0)
	subweapon0 = HOLYWATER if subweapon0 == SICKLERANG else (KNIFE if subweapon0 == HOLYWATER else SICKLERANG)


func _on_button3_button_down():
	if get_parent().get_node("Player").mana >= 30:
		get_parent().get_node("Player").mana -= 30
		get_parent().get_node("Player").health += 10
