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



static func generate_level(map: TileMap,ground_layer :int, block_layer :int, ground_atlas :int, block_atlas :int) -> void:
	generate_boundaries(map, ground_layer, block_layer, ground_atlas, block_atlas)


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
