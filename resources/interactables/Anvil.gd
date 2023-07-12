extends StaticBody2D

class_name Anvil

@export var crafting_time :float
@onready var crafting_timer := $CraftingTimer
@onready var loading_ring := $LoadingRing

var player = null


func do_interaction() -> void:
	if player == null:
		player = $InteractableBase.player
	
	if crafting_timer.is_stopped() and player.ore_pouch > 0 and player.weapon.needs_crafting():
		if !loading_ring.visible:
			update_ring()
			loading_ring.set_deferred("visible", true)
		crafting_timer.wait_time = crafting_time
		crafting_timer.start()
	elif not (player.ore_pouch > 0 and player.weapon.needs_crafting()) and loading_ring.visible:
			loading_ring.set_deferred("visible", false)


func stop_interaction() -> void:
	if not crafting_timer.is_stopped():
		crafting_timer.stop()
	loading_ring.set_deferred("visible", false)


func update_ring() -> void:
	loading_ring.max_value = player.weapon.get_max_restorable()
	loading_ring.value = player.weapon.get_current_restorable()


func _on_crafting_timer_timeout():
	var stack = player.ore_pouch >= 5 and player.weapon.needs_crafting(true)
	player.weapon.crafted(stack)
	player.ore_pouch -= 5 if stack else 1
	update_ring()
	crafting_timer.stop()
