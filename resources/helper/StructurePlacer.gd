extends Node


class_name StructurePlacer

const nope_atlas = 3



static func place_structure(structure_name :StructureHelper.General, pos :Vector2i, map: TileMap,ground_layer :int, block_layer :int, ground_atlas :int, block_atlas :int) -> void:
	# First: Gotta get the patterns
	var ground_pattern = StructureHelper.get_structure_pattern(structure_name, ground_layer)
	var block_pattern = StructureHelper.get_structure_pattern(structure_name, block_layer)
	var ground_offset = StructureHelper.get_ground_offset(structure_name)
	
	# Rounding because we need a size of 9 to be reduced to 5 and not 4 - only relevant for y axis tho (apparently)
	var new_pos = pos - Vector2i(block_pattern.get_size().x / 2, round(block_pattern.get_size().y / 2.0))
	
	# Create the physical boundaries
	spawn_pattern(ground_pattern, block_pattern, new_pos, ground_offset, map, ground_layer, block_layer, ground_atlas, block_atlas)
	# Gotta spawn in interactables
	for interactable in StructureHelper.get_static_things(structure_name, "Interactables"):
		spawn_thing_in_scene(interactable[0], map.map_to_local(interactable[1] + pos), map.owner.get_node("Interactables"))
	# Gotta spawn decor
	for decor in StructureHelper.get_static_things(structure_name, "Decor"):
		spawn_thing_in_scene(decor[0], map.map_to_local(decor[1] + pos), map.owner.get_node("Decor"))
	# Gotta spawn enemies
	for enemy in StructureHelper.get_non_static_things(structure_name, "Enemies"):
		spawn_thing_in_scene(enemy[0], enemy[1], map.owner.get_node("Enemies"))


static func spawn_pattern(ground_pattern :TileMapPattern, block_pattern :TileMapPattern, pos :Vector2i, ground_offset :Vector2i, map: TileMap,ground_layer :int, block_layer :int, ground_atlas :int, block_atlas :int) -> void:
	var ground_pos = pos + ground_offset
	var cleanup_pos = Vector2i(min(pos.x, ground_pos.x),min(pos.y, ground_pos.y))
	
	# Spawn in saved pattern
	map.set_pattern(block_layer, pos, block_pattern)
	map.set_pattern(ground_layer,ground_pos, ground_pattern)
	
	# Clean-Up Nopes, swap tops, remove wrong walls, add walls
	var block_size = block_pattern.get_size()
	var ground_size = ground_pattern.get_size()
	var cleanup_size = Vector2i(max(block_size.x, ground_size.x),max(block_size.y, ground_size.y))
	# +1 to also get the row below the structure
	for y in range(cleanup_size.y + 1):
		for x in range(cleanup_size.x):
			var cur_pos = Vector2i(cleanup_pos.x + x, cleanup_pos.y + y)
			var cell_above = map.get_neighbor_cell(cur_pos,TileSet.CELL_NEIGHBOR_TOP_SIDE)
			
			# Nope Cleanup
			if map.get_cell_source_id(ground_layer, cur_pos) == nope_atlas:
				map.erase_cell(ground_layer, cur_pos)
			if map.get_cell_source_id(block_layer,cur_pos) == nope_atlas:
				map.erase_cell(block_layer, cur_pos)
			
			# Swap Tops if necessary
			if map.get_cell_source_id(block_layer, cur_pos) != -1 and map.get_cell_alternative_tile(block_layer, cur_pos) == 0 and map.get_cell_atlas_coords(block_layer, cur_pos).y == 0:
				# Standard-Top. Need to check if above is free!
				if map.get_cell_source_id(block_layer, cell_above) == -1:
					# Nothing above! Swap to different top and new set ground with minimal nav
					map.set_cell(block_layer, cur_pos, block_atlas, map.get_cell_atlas_coords(block_layer, cur_pos), 1)
					map.set_cell(ground_layer, cur_pos, ground_atlas, Vector2i(0,0), 1)
			
			# Eliminate unnecessary walls
			if map.get_cell_source_id(block_layer, cur_pos) != -1 and map.get_cell_atlas_coords(block_layer, cur_pos).y == 1:
				if map.get_cell_source_id(block_layer, cell_above) == -1:
					# No block above wall! Kill wall
					map.erase_cell(block_layer, cur_pos)
					map.set_cell(ground_layer, cur_pos, ground_atlas, Vector2i(0,0), 0)
			
			
			# Place walls if necessary
			if map.get_cell_source_id(block_layer, cur_pos) != -1 and map.get_cell_atlas_coords(block_layer, cur_pos).y == 0:
				# It's a top! Let's see if it needs a wall below it
				var cell_below = map.get_neighbor_cell(cur_pos,TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
				if map.get_cell_source_id(block_layer, cell_below) == -1:
					# Nothing below! Needs wall! And ground with no nav
					map.set_cell(block_layer, cell_below, block_atlas, Vector2i(map.get_cell_atlas_coords(block_layer, cur_pos).x, 1))
					map.set_cell(ground_layer, cell_below, ground_atlas, Vector2i(0,0), 2)
				elif map.get_cell_atlas_coords(block_layer,cell_below).y == 1:
					# Already a wall! Let's make sure it's the right one!
					map.set_cell(block_layer, cell_below, block_atlas, Vector2i(map.get_cell_atlas_coords(block_layer, cur_pos).x, 1))
			


static func spawn_thing_in_scene(scene :PackedScene, pos: Vector2, node_to_spawn_it_in :Node) -> void:
	var thing = scene.instantiate()
	thing.position = pos
	node_to_spawn_it_in.add_child(thing)
