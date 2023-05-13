extends Equipment

class_name MiningEquipment

@onready var miningComponent :MiningComponent = MiningComponent.new()

func update(player: Player) -> void:
	for child in get_children():
		if child.has_method("update"):
			child.update(player)

func act(player: Player, delta: float) -> void:
	var collision :RayCast2D = $RayCast2D
	miningComponent.mine(delta, collision)
	
func do_rotation(player: Player) -> void:
	$Anglepoint.aim_at_mouse_basic(player)
