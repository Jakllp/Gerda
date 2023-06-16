extends CanvasLayer

var atlas := preload("res://asset/visual/UI/HUD_Elements.png")
var dash_full_tex := AtlasTexture.new()
var dash_empty_tex := AtlasTexture.new()
const minimum_dash_size := Vector2(112,21)
@onready var ore_label = $Right/Ore/Amount/Ore
@onready var mining_speed_label = $Left/PlayerUpgrades/Upgrade1/Amount/MiningSpeed
@onready var walk_speed_label = $Left/PlayerUpgrades/Upgrade2/Amount/WalkSpeed
@onready var dash_cooldown_label = $Left/PlayerUpgrades/Upgrade3/Amount/DashCooldown
@onready var weapon_speed_label = $Bottom/VBoxContainer/WeaponInfo/WeaponUpgrades/Upgrade1/Amount/Speed
@onready var weapon_damage_label = $Bottom/VBoxContainer/WeaponInfo/WeaponUpgrades/Upgrade2/Amount/Damage
@onready var weapon_rate_label = $Bottom/VBoxContainer/WeaponInfo/WeaponUpgrades/Upgrade3/Amount/Rate
@onready var magazine_label = $Bottom/VBoxContainer/WeaponInfo/Ammo/CurrentMagazine
@onready var ammo_label = $Bottom/VBoxContainer/WeaponInfo/Ammo/RemainingAmmo
@onready var dashes = $Bottom/VBoxContainer/Dashes

# Called when the node enters the scene tree for the first time.
func _ready():
	# initializing textures
	dash_full_tex.atlas = atlas
	dash_full_tex.region.position = Vector2(0,24)
	dash_full_tex.region.size = Vector2(16,3)
	dash_empty_tex.atlas = atlas
	dash_empty_tex.region.position = Vector2(16,24)
	dash_empty_tex.region.size = Vector2(16,3)
	
	# connecting signals
	var player:Player = get_tree().get_first_node_in_group("player")
	player.ore_changed.connect(on_ore_changed)
	player.player_upgrade_received.connect(on_player_upgrade_received)
	player.weapon.weapon_upgrade_received.connect(on_weapon_upgrade_received)
	player.weapon.mag_contents_changed.connect(on_mag_contents_changed)
	player.weapon.ammo_stored_changed.connect(on_ammo_stored_changed)
	player.dash_max_amount_changed.connect(on_dash_max_amount_changed)
	player.dashes_left_changed.connect(on_dashes_left_changed)
	

func on_ore_changed(amount:int) -> void:
	ore_label.text = str(amount)
	

func on_player_upgrade_received(type: Upgrade.Player_Upgrade) -> void:
	match type:
		Upgrade.Player_Upgrade.WALK_SPEED:
			walk_speed_label.text = str(walk_speed_label.text.to_int() + 1)
		Upgrade.Player_Upgrade.DASH_COOLDOWN:
			dash_cooldown_label.text = str(dash_cooldown_label.text.to_int() + 1)
		Upgrade.Player_Upgrade.MINING_SPEED:
			mining_speed_label.text = str(mining_speed_label.text.to_int() + 1)
		

func on_weapon_upgrade_received(type: Upgrade.Weapon_Upgrade) -> void:
	match type:
		Upgrade.Weapon_Upgrade.DAMAGE:
			weapon_speed_label.text = str(weapon_speed_label.text.to_int() + 1)
		Upgrade.Weapon_Upgrade.ATTACK_RATE:
			weapon_rate_label.text = str(weapon_rate_label.text.to_int() + 1)
		Upgrade.Weapon_Upgrade.SPEED:
			weapon_speed_label.text = str(weapon_speed_label.text.to_int() + 1)


func on_mag_contents_changed(value: int) -> void:
	magazine_label.text = str(value)


func on_ammo_stored_changed(value: int) -> void:
	ammo_label.text = str(value)


func on_dash_max_amount_changed(value: int) -> void:
	var diff = value - dashes.get_child_count()
	
	if diff > 0:
			while(dashes.get_child_count() != value):
				if dashes.get_child_count() == 0:
					var dash_tex_rec = TextureRect.new()
					dash_tex_rec.texture = dash_full_tex
					dash_tex_rec.custom_minimum_size = minimum_dash_size
					dashes.add_child(dash_tex_rec)
				else:
					dashes.add_child(dashes.get_child(0).duplicate())
	else:
		while(dashes.get_child_count() != value):
			var child = dashes.get_child(0)
			dashes.remove_child(child)
			child.queue_free()
	

func on_dashes_left_changed(previous: int, diff: int) -> void:	
	if diff > 0:
		for i in range(previous, previous + diff):
			dashes.get_child(i).texture = dash_full_tex
	else:
		for i in range(previous-1, previous + diff - 1, -1):
			dashes.get_child(i).texture = dash_empty_tex
	
#var amount = 2
#func _process(delta):
#	if Input.is_action_just_pressed("ui_up"):
#		on_dashes_left_changed(amount, 1)
#		amount += 1
#	elif Input.is_action_just_pressed("ui_down"):
#		on_dashes_left_changed(amount, -1)
#		amount -= 1
