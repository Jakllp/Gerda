extends Equipment

class_name Weapon


@export var restore_per_craft :int

var active_upgrades = {}

func _ready() -> void:
	# Fill upgrades
	for x in Upgrade.Weapon_Upgrade:
		active_upgrades[x] = 0


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
