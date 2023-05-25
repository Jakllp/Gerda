extends Equipment

class_name Weapon


@export var restore_per_craft :int


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
