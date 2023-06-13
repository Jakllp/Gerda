extends Node

## Creates the world
class_name God

const general_width = 200
const general_height = 200
const level_width = 150
const level_height = 150
# Demo calculation: 200x200 general, 150x150 inner
# Should result in 0 to 74 to the right and -1 to -75 to the left.
# Should result in 0 to 74 to the bottom and -1 to -75 to the top.

enum BlockType {
	GROUND,
	BLOCK,
	ORE
}


static func generate_level(map: TileMap,ground_layer :int, block_layer :int, ground_atlas :int, block_atlas :int) -> void:
	generate_boundaries(map, ground_layer, block_layer, ground_atlas, block_atlas)
	generate_caves_and_ore(map, ground_layer, block_layer, ground_atlas, block_atlas, PerlinHelper.generate_heightmap())

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


static func generate_caves_and_ore(map: TileMap, ground_layer :int, block_layer :int, ground_atlas :int, block_atlas :int, heightmap :FastNoiseLite) -> void:
	var start_x = level_width / -2
	# -1 because of the way we see the map
	var start_y = level_height / -2 - 1
	var min = 2.0
	var max = 0.0
	
	for y in range(level_height):
		for x in range(level_width):
			var cur_block = heightmap.get_noise_2d(start_x + x, start_y + y)
			if cur_block < min: min = cur_block
			if cur_block > max: max = cur_block
			
			var block_above = heightmap.get_noise_2d(start_x+x, start_y + y - 1)
			var cur_cell = Vector2i(start_x + x, start_y + y)
			match get_block_type(cur_block):
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
			
	print(min)
	print(max)


static func get_block_type(height :float) -> BlockType:
	if height <= -0.15:
		return BlockType.GROUND
	elif height <= 0.14 and height >=0.13:
		# More range -> Bigger chunks
		# Higher values -> Less in general
		return BlockType.ORE
	else:
		return BlockType.BLOCK
