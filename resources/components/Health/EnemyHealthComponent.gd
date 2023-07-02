extends HealthComponent
class_name EnemyHealthComponent

## probability to drop an item on death
@export var item_drop_chance := 0.15

func die() -> void:
	if randf() < item_drop_chance:
		var drop: Item = ItemCreator.create_enemy_drop_item()
		drop.global_position = owner.global_position
		get_tree().get_first_node_in_group("interactables").call_deferred("add_child", drop)
	super.die()
