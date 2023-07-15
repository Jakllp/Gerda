extends Control

const atlas := preload("res://asset/visual/UI/HUD_Elements.png")
const mutator_atlas := preload("res://asset/visual/UI/Mutators.png")

var dash_full_tex := AtlasTexture.new()
var dash_empty_tex := AtlasTexture.new()
const minimum_dash_size := Vector2(112,21)

var heart_full_tex := AtlasTexture.new()
var heart_half_tex := AtlasTexture.new()
var heart_empty_tex := AtlasTexture.new()
const minimum_heart_size := Vector2(40,40)
const minimum_mutator_size := Vector2(66, 54)

@onready var ore_label = $Right/Right/Ore/Amount/Ore
@onready var mining_speed_label = $Left/Left/PlayerUpgrades/Upgrade1/Amount/MiningSpeed
@onready var walk_speed_label = $Left/Left/PlayerUpgrades/Upgrade2/Amount/WalkSpeed
@onready var dash_cooldown_label = $Left/Left/PlayerUpgrades/Upgrade3/Amount/DashCooldown
@onready var weapon_speed_label = $Bottom/Bottom/VBoxContainer/WeaponInfo/WeaponUpgrades/Upgrade1/Amount/Speed
@onready var weapon_damage_label = $Bottom/Bottom/VBoxContainer/WeaponInfo/WeaponUpgrades/Upgrade2/Amount/Damage
@onready var weapon_rate_label = $Bottom/Bottom/VBoxContainer/WeaponInfo/WeaponUpgrades/Upgrade3/Amount/Rate
@onready var magazine_label = $Bottom/Bottom/VBoxContainer/WeaponInfo/Ammo/CurrentMagazine
@onready var ammo_label = $Bottom/Bottom/VBoxContainer/WeaponInfo/Ammo/RemainingAmmo
@onready var dashes = $Bottom/Bottom/VBoxContainer/Dashes
@onready var health = $Left/Left/Health
@onready var mutators = $Right/Right/Mutators

# Called when the node enters the scene tree for the first time.
func _ready():
	# initializing textures
	dash_full_tex.atlas = atlas
	dash_full_tex.region.position = Vector2(0,24)
	dash_full_tex.region.size = Vector2(16,3)
	dash_empty_tex.atlas = atlas
	dash_empty_tex.region.position = Vector2(16,24)
	dash_empty_tex.region.size = Vector2(16,3)
	
	heart_full_tex.atlas = atlas
	heart_full_tex.region.position = Vector2.ZERO
	heart_full_tex.region.size = Vector2(8,8)
	heart_half_tex.atlas = atlas
	heart_half_tex.region.position = Vector2(0,8)
	heart_half_tex.region.size = Vector2(8,8)
	heart_empty_tex.atlas = atlas
	heart_empty_tex.region.position = Vector2(0,16)
	heart_empty_tex.region.size = Vector2(8,8)
	
	# connect signals
	var player = get_tree().get_first_node_in_group("player")
	player.ore_changed.connect(on_ore_changed)
	player.player_upgrade_received.connect(on_player_upgrade_received)
	player.weapon.weapon_upgrade_received.connect(on_weapon_upgrade_received)
	player.weapon.mag_contents_changed.connect(on_mag_contents_changed)
	player.weapon.ammo_stored_changed.connect(on_ammo_stored_changed)
	player.dash_max_amount_changed.connect(on_dash_max_amount_changed)
	player.dashes_left_changed.connect(on_dashes_left_changed)
	player.get_node("PlayerHealthComponent").max_hp_changed.connect(on_max_hp_changed)
	player.get_node("PlayerHealthComponent").hp_changed.connect(on_hp_changed)
	

func on_ore_changed(amount:int) -> void:
	ore_label.text = str(amount)
	

func on_player_upgrade_received(type: Items.Type) -> void:
	match type:
		Items.Type.WALK_SPEED:
			walk_speed_label.text = str(walk_speed_label.text.to_int() + 1)
		Items.Type.DASH_COOLDOWN:
			dash_cooldown_label.text = str(dash_cooldown_label.text.to_int() + 1)
		Items.Type.MINING_SPEED:
			mining_speed_label.text = str(mining_speed_label.text.to_int() + 1)
		

func on_weapon_upgrade_received(type: Items.Type) -> void:
	match type:
		Items.Type.DAMAGE:
			weapon_damage_label.text = str(weapon_damage_label.text.to_int() + 1)
		Items.Type.ATTACK_RATE:
			weapon_rate_label.text = str(weapon_rate_label.text.to_int() + 1)
		Items.Type.WEAPON_SPEED:
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
	

func on_max_hp_changed(value) -> void:
	var diff = value/2 - health.get_child_count()
	
	if diff > 0:
			while(health.get_child_count() != value/2):
				if health.get_child_count() == 0:
					var health_tex_rec = TextureRect.new()
					health_tex_rec.texture = heart_full_tex
					health_tex_rec.custom_minimum_size = minimum_heart_size
					health.add_child(health_tex_rec)
				else:
					health.add_child(health.get_child(health.get_child_count()-1).duplicate())
	else:
		while(health.get_child_count() != value/2):
			var child = health.get_child(0)
			health.remove_child(child)
			child.queue_free()
			

func on_hp_changed(previous, diff) -> void:
	printt(previous,diff)
	var start = floor(previous/2)
	var end = floor((previous+diff) / 2)
	var half := bool((previous+diff) % 2)
	
	if diff > 0:
		for i in range(start, end):
			health.get_child(i).texture = heart_full_tex
	else:
		for i in range(start - int(previous%2 == 0), end - int(!half), -1):
			health.get_child(i).texture = heart_empty_tex
	if half:
		health.get_child(end).texture = heart_half_tex


func add_mutator(mutator) -> void:
	var mutator_tex_rec = TextureRect.new()
	var mutator_tex = AtlasTexture.new()
	mutator_tex.atlas = mutator_atlas
	mutator_tex_rec.custom_minimum_size = minimum_mutator_size
	mutator_tex.region = Rect2(mutator.texture,Vector2(11, 9))
	mutator_tex_rec.texture = mutator_tex
	mutators.add_child(mutator_tex_rec)

#var amount = 8
#var diff = 4
#func _process(delta):
#	if Input.is_action_just_pressed("ui_up"):
#		on_hp_changed(amount, diff)
#		amount += diff
#	elif Input.is_action_just_pressed("ui_down"):
#		on_hp_changed(amount, -diff)
#		amount -= diff
