extends CanvasLayer

@onready var ore_label = $Right/Ore/anzahl/ore
@onready var player_up_1 = $"Left/Player Upgrades/upgrade 1/anzahl/plUp1"
@onready var player_up_2 = $"Left/Player Upgrades/upgrade 2/anzahl/plUp2"
@onready var player_up_3 = $"Left/Player Upgrades/upgrade 3/anzahl/plUp3"
@onready var weapon_up_1 = $"Bottom/VBoxContainer/Weapon info/Weapon Upgrades/upgrade 1/anzahl/weapUp1"
@onready var weapon_up_2 = $"Bottom/VBoxContainer/Weapon info/Weapon Upgrades/upgrade 2/anzahl/weapUp2"
@onready var weapon_up_3 = $"Bottom/VBoxContainer/Weapon info/Weapon Upgrades/upgrade 3/anzahl/weapUp3"
@onready var magazine = $"Bottom/VBoxContainer/Weapon info/Ammo/Current Magazine"
@onready var ammo = $"Bottom/VBoxContainer/Weapon info/Ammo/Remaining ammo"

# Called when the node enters the scene tree for the first time.
func _ready():
	var player:Player = get_tree().get_first_node_in_group("player")
	player.ore_changed.connect(on_ore_changed)


func on_ore_changed(amount:int):
	ore_label.text = str(amount)


#func _process(delta):
#	if Input.is_action_just_pressed("down"):
#		on_ore_changed(1)
