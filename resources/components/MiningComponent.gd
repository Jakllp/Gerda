extends RefCounted

class_name MiningComponent

var rng = RandomNumberGenerator.new()
var min_ore_from_ore := 1
var max_ore_from_ore := 2
## How much percent the mining speed goes up (from the base mining speed)
var mining_speed_upgrade_modifier := 0.2

## How many damage it deals per second
var base_mining_speed = 10


func mine(delta: float, collision: RayCast2D, player:Player=null) -> int:
	if collision.is_colliding() and collision.get_collider() is TileMap:
		# Get the cell on the map
		var cell_rid = collision.get_collider_rid()
		var map :TileMap = collision.get_collider()
		var cell = map.get_coords_for_body_rid(cell_rid)
		
		#Sometimes this update and the cell breaking don't align properly
		if(map.get_cell_tile_data(map.get("block_layer"), cell) == null):
			return 0
		
		var cell_hardness = map.get_cell_tile_data(map.get("block_layer"), cell).get_custom_data("hardness")
		# These cells are impossible to mine
		if cell_hardness == -1:
			return 0
		
		# Actually mine (aka reduce health of that point)
		var was_ore :bool
		if(player!=null):
			var speedup = (base_mining_speed * mining_speed_upgrade_modifier/100) * player.active_upgrades[Items.Type.MINING_SPEED]
			was_ore = map.damage_cell(cell, delta * base_mining_speed + speedup)
		else:
			was_ore = map.damage_cell(cell, delta * base_mining_speed)
		
		if was_ore:
			# In this case we actually destroyed an ore
			var ore_amount := rng.randi_range(min_ore_from_ore, max_ore_from_ore)
			return ore_amount
	return 0
