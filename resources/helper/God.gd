extends Node

## Creates the world
class_name God

const general_width = 150
const general_height = 150
const level_width = 100
const level_height = 100
# Demo calculation: 200x200 general, 150x150 inner
# Should result in 0 to 74 to the right and -1 to -75 to the left.
# Should result in 0 to 74 to the bottom and -1 to -75 to the top.

const nope_atlas = 3

enum BlockType {
	GROUND,
	BLOCK,
	ORE
}


static func generate_level(map: TileMap,ground_layer :int, block_layer :int, ground_atlas :int, block_atlas :int) -> void:
	generate_boundaries(map, ground_layer, block_layer, ground_atlas, block_atlas)
	generate_caves_and_ore(map, ground_layer, block_layer, ground_atlas, block_atlas)
	
	# Spawn trapdoor-room
	spawn_pattern(0, Vector2i(-2, -2), Vector2i(0, 0), map, ground_layer, block_layer, ground_atlas, block_atlas)

static func generate_boundaries(map: TileMap, ground_layer :int, block_layer :int, ground_atlas :int, block_atlas :int) -> void:
	# Let's fill in the sides (already filling the corners)
	var horizontal_boundary_width = (general_width - level_width) / 2
	# This does not need to take the coordinate-stuff described above into account as the first run will have i=0 -> -100
	var starting_point_y = general_height / -2
	for i in range(general_height):
		# Left side
		var starting_point_x = general_width / -2
		for j in range(horizontal_boundary_width):
			map.set_cell(block_layer,Vector2i(starting_point_x+j,starting_point_y+i),block_atlas, Vector2i(4,0), 0)
		# Right side - starts at 75 as 74 is actually the 75th block into that direction
		starting_point_x = level_width / 2
		for j in range(horizontal_boundary_width):
			map.set_cell(block_layer,Vector2i(starting_point_x+j,starting_point_y+i),block_atlas, Vector2i(4,0), 0)
	
	# Now let's do top and bottom (no corners bc we have special blocks)
	var vertical_boundary_width = (general_height - level_height) / 2
	# This does not need to take the coordinate-stuff described above into account as the first run will have i=0 -> -75
	var starting_point_x = level_width / -2
	for i in range(level_width):
		# Top
		starting_point_y = general_height / -2 
		for j in range(vertical_boundary_width):
			if j + 1 == vertical_boundary_width:
				# Last run needs to put wall-blocks down
				map.set_cell(block_layer,Vector2i(starting_point_x+i,starting_point_y+j),block_atlas, Vector2i(4,1), 0)
				# Also needs floor below it as a precaution
				map.set_cell(ground_layer,Vector2i(starting_point_x+i,starting_point_y+j),ground_atlas, Vector2i(0,0), 2)
			else:
				map.set_cell(block_layer,Vector2i(starting_point_x+i,starting_point_y+j),block_atlas, Vector2i(4,0), 0)
		# Bottom - starts at 74 even tho 74 is actually the 75th block into that direction so should still be clear.
		# See explanation below
		starting_point_y = level_height / 2 - 1
		for j in range(vertical_boundary_width + 1):
			# Lemme explain the +1 and -1 and in general what's happening here:
			# Birds-eye our playing field is 150x150 BUT our perspective is not birds-eye
			# The bottom field is blocked visually by a top-layer (otherwise it would have a wall there which doesn't make any sense)
			# So therefore we not only fill the 25 BUT one more block which the player can actually enter
			# The top boundary having a wall towards the playing-area
			if j == 0:
				# Special-Tops
				map.set_cell(block_layer,Vector2i(starting_point_x+i,starting_point_y+j),block_atlas, Vector2i(4,0), 1)
				# Also needs floor below it as a precaution
				map.set_cell(ground_layer,Vector2i(starting_point_x+i,starting_point_y+j),ground_atlas, Vector2i(0,0), 1)
			else:
				#Normal-Tops aka normal boundary
				map.set_cell(block_layer,Vector2i(starting_point_x+i,starting_point_y+j),block_atlas, Vector2i(4,0), 0)


static func generate_caves_and_ore(map: TileMap, ground_layer :int, block_layer :int, ground_atlas :int, block_atlas :int) -> void:
	var block_heightmap :FastNoiseLite = PerlinHelper.generate_heightmap(0.1, 4, 0.25, 0.5)
	# Lower gain to get bigger chunks, higher frequency to get... more
	var ore_heightmap :FastNoiseLite = PerlinHelper.generate_heightmap(0.35, 2, 5.0, 0.3)
	
	var start_x = level_width / -2
	# -1 because of the way we see the map
	var start_y = level_height / -2 - 1
	
	for y in range(level_height):
		for x in range(level_width):
			var cur_block = block_heightmap.get_noise_2d(start_x + x, start_y + y)
			var cur_block_ore = ore_heightmap.get_noise_2d(start_x + x, start_y + y)
			
			var block_above = block_heightmap.get_noise_2d(start_x+x, start_y + y - 1)
			var cur_cell = Vector2i(start_x + x, start_y + y)
			match get_block_type(cur_block, cur_block_ore):
				BlockType.GROUND:
					if y != 0 and get_block_type(block_above) == BlockType.GROUND:
						# Just standard ground
						map.set_cell(ground_layer,cur_cell,ground_atlas, Vector2i(0,0), 0)
					else:
						# There is some type of Block (So BlockType.GROUND or BlockType.ORE) above
						# Need to make a wall AND ground without nav
						var above_cell := map.get_neighbor_cell(cur_cell,TileSet.CELL_NEIGHBOR_TOP_SIDE)
						var above_atlas_x := map.get_cell_atlas_coords(block_layer,above_cell).x
						map.set_cell(block_layer,cur_cell,block_atlas, Vector2i(above_atlas_x,1), 0)
						map.set_cell(ground_layer,cur_cell,ground_atlas, Vector2i(0,0), 2)
				BlockType.BLOCK:
					var alt = 0
					if y == 0:
						# Special handling for top-row
						map.erase_cell(ground_layer, cur_cell)
					elif get_block_type(block_above) == BlockType.GROUND:
						# It's a Top-Block -> Needs special Hitbox (alt) and Ground
						alt = 1
						map.set_cell(ground_layer,cur_cell,ground_atlas, Vector2i(0,0), 1)
					# Set the block with the needed alternative
					map.set_cell(block_layer,cur_cell,block_atlas, Vector2i(0,0), alt)
				BlockType.ORE:
					var alt = 0
					if y == 0:
						# Special handling for top-row
						map.erase_cell(ground_layer, cur_cell)
					elif get_block_type(block_above) == BlockType.GROUND:
						# It's a Top-Block -> Needs special Hitbox (alt) and Ground
						alt = 1
						map.set_cell(ground_layer,cur_cell,ground_atlas, Vector2i(1,0), 1)
					# Set the block with the needed alternative
					map.set_cell(block_layer,cur_cell,block_atlas, Vector2i(1,0), alt)
				_:
					pass


## Get's the block type of a given height-combination
static func get_block_type(height :float, height_ore :float = 0.0) -> BlockType:
	# The lower this number the more blocks you get
	if height <= -0.075:
		return BlockType.GROUND
	elif height_ore > 0.425:
		return BlockType.ORE
	else:
		return BlockType.BLOCK


static func spawn_pattern(pattern_num :int, pos :Vector2i, ground_offset :Vector2i, map: TileMap,ground_layer :int, block_layer :int, ground_atlas :int, block_atlas :int) -> void:
	var ground_pos = pos + ground_offset
	var cleanup_pos = Vector2i(min(pos.x, ground_pos.x),min(pos.y, ground_pos.y))
	
	# Spawn in saved pattern
	map.set_pattern(block_layer,pos, map.tile_set.get_pattern(pattern_num*2))
	map.set_pattern(ground_layer,ground_pos, map.tile_set.get_pattern(pattern_num*2+1))
	
	# Clean-Up Nopes, swap tops, add walls
	var block_size = map.tile_set.get_pattern(pattern_num).get_size()
	var ground_size = map.tile_set.get_pattern(pattern_num+1).get_size()
	var cleanup_size = Vector2i(max(block_size.x, ground_size.x),max(block_size.y, ground_size.y))
	for y in range(cleanup_size.y + 1):
		for x in range(cleanup_size.x):
			var cur_pos = Vector2i(cleanup_pos.x + x, cleanup_pos.y + y)
			
			# Nope Cleanup
			if map.get_cell_source_id(ground_layer, cur_pos) == nope_atlas:
				map.erase_cell(ground_layer, cur_pos)
			if map.get_cell_source_id(block_layer,cur_pos) == nope_atlas:
				map.erase_cell(block_layer, cur_pos)
			
			# Swap Tops if necessary
			if map.get_cell_source_id(block_layer, cur_pos) != -1 and map.get_cell_alternative_tile(block_layer, cur_pos) == 0 and map.get_cell_atlas_coords(block_layer, cur_pos).y == 0:
				# Standard-Top. Need to check if above is free!
				if map.get_cell_source_id(block_layer, map.get_neighbor_cell(cur_pos,TileSet.CELL_NEIGHBOR_TOP_SIDE)) == -1:
					# Nothing above! Swap to different top and new set ground with minimal nav
					map.set_cell(block_layer, cur_pos, block_atlas, map.get_cell_atlas_coords(block_layer, cur_pos), 1)
					map.set_cell(ground_layer, cur_pos, ground_atlas, Vector2i(0,0), 1)

			# Place walls if necessary
			if map.get_cell_source_id(block_layer, cur_pos) != -1 and map.get_cell_atlas_coords(block_layer, cur_pos).y == 0:
				# It's a top! Let's see if it needs a wall below it
				var cell_below = map.get_neighbor_cell(cur_pos,TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
				if map.get_cell_source_id(block_layer, cell_below) == -1:
					# Nothing below! Needs wall! And ground with no nav
					map.set_cell(block_layer, cell_below, block_atlas, Vector2i(map.get_cell_atlas_coords(block_layer, cur_pos).x, 1))
					map.set_cell(ground_layer, cell_below, ground_atlas, Vector2i(0,0), 2)
	# TODO: Gotta also place all the things
