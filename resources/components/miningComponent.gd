extends Node

class_name MiningComponent


# Aka how many damage it deals per second
var mining_speed = 10


func mine(delta: float, collision: RayCast2D) -> void:
	if collision.is_colliding() and collision.get_collider() is TileMap:		
		# Get map and point
		var point := collision.get_collision_point()
		print("point" + str(point))
		var map :TileMap = collision.get_collider()
		var scale := map.scale
		print("scale: " + str(scale))
		point /= map.scale

		var normal = collision.get_collision_normal()
		print("normal: " + str(normal))
		point -= normal
		print("point modified: " + str(point))

		# Convert to actual tilemap-point
		var cell = map.local_to_map(point)
		print(cell)
		print("\n")
		
		#Sometimes this update and the cell breaking don't align properly
		if(map.get_cell_tile_data(map.get("block_layer"), cell) == null):
			return
		
		var cell_hardness = map.get_cell_tile_data(map.get("block_layer"), cell).get_custom_data("hardness")
		# These cells are impossible to mine
		if cell_hardness == -1:
			return
		
		# Actually mine (aka reduce health of that point)
		if(map.damage_cell(cell, delta * mining_speed)):
			# In this case we actually destroyed an ore
			# TODO implement ore logic
			print("ORE")
