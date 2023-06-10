extends CanvasLayer

@onready var ore_label = $Right/Ore/anzahl/ore
@onready var mining_speed_label = $Left/PlayerUpgrades/Upgrade1/Amount/MiningSpeed
@onready var walk_speed_label = $Left/PlayerUpgrades/Upgrade2/Amount/WalkSpeed
@onready var dash_cooldown_label = $Left/PlayerUpgrades/Upgrade3/Amount/DashCooldown
@onready var weapon_speed_label = $Bottom/VBoxContainer/WeaponInfo/WeaponUpgrades/Upgrade1/Amount/Speed
@onready var weapon_damage_label = $Bottom/VBoxContainer/WeaponInfo/WeaponUpgrades/Upgrade2/Amount/Damage
@onready var weapon_rate_label = $Bottom/VBoxContainer/WeaponInfo/WeaponUpgrades/Upgrade3/Amount/Rate
@onready var magazine_label = $Bottom/VBoxContainer/WeaponInfo/Ammo/CurrentMagazine
@onready var ammo_label = $Bottom/VBoxContainer/WeaponInfo/Ammo/RemainingAmmo

# Called when the node enters the scene tree for the first time.
func _ready():
	var player:Player = get_tree().get_first_node_in_group("player")
	player.ore_changed.connect(on_ore_changed)


func on_ore_changed(amount:int):
	ore_label.text = str(amount)


#func _process(delta):
#	if Input.is_action_just_pressed("down"):
#		on_ore_changed(1)
