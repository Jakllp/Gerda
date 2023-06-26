extends Equipment

class_name Weapon


@export var restore_per_craft :int
@export var base_damage :int
## Percent of base_damage added for every upgrade
@export var damage_upgrade_modifier :int
@onready var active_upgrades = {}

signal weapon_upgrade_received(type)


func _ready() -> void:
	# Fill upgrades
	for x in Items.upgrade_category["weapon"]:
		active_upgrades[x] = 0


func add_upgrade(upgrade: Items.Type):
	weapon_upgrade_received.emit(upgrade)
	active_upgrades[upgrade] += 1
	print(str(Items.Type.keys()[upgrade])+" now at "+str(active_upgrades[upgrade]))


func update(player: Player) -> void:
	pass


func act(player: Player, delta: float) -> void:
	pass
	

func do_rotation(player: Player) -> void:
	pass


func needs_crafting() -> bool:
	return false


func crafted() -> void:
	pass
