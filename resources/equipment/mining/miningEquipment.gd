extends Equipment

class_name MiningEquipment

var mining_component :MiningComponent = MiningComponent.new()

func update(player: Player) -> void:
	for child in get_children():
		if child.has_method("update"):
			child.update(player)
	

func act(player: Player, delta: float) -> void:
	var collision :RayCast2D = $RayCast2D
	$AnimationPlayer.play("wiggle")
	var mined_ore = mining_component.mine(delta, collision)
	if mined_ore != 0:
		owner.ore_pouch += mined_ore
	

func do_rotation(player: Player) -> void:
	$Anglepoint.aim_at_mouse_basic(player)
