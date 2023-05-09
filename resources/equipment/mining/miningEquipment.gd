extends Equipment

class_name MiningEquipment

@onready var miningComponent :MiningComponent = MiningComponent.new()

func update(player: Player) -> void:
	miningComponent.update(player)
	for child in get_children():
		if child.has_method("update"):
			child.update(player)

func act(player: Player, delta: float) -> bool:
	var collision :RayCast2D = $RayCast2D
	return miningComponent.mine(delta, collision)
