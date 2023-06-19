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
## The inner-percentage of the map where stuff can spawn
const inner_spawn_range = 0.7
## The percentage of how far away from a corner the anvil-room can spawn
const corner_anvil_range = 0.1

const inner_anvil_spawns = 1
const default_dungeon_spawns = 6
const min_spawn_distance = 20

const special_ground_amount = 650


enum BlockType {
	GROUND,
	BLOCK,
	ORE
}

# Note: If there ever should be different trapdoor-rooms for different biomes this method would need a new input and we'd need to implement a biome-checker for other functions down the line
## Delegates the generation of the level
static func generate_level(map: TileMap,ground_layer :int, block_layer :int, ground_atlas :int, block_atlas :int, biome :int) -> Vector2i:
	var dungeon_spawns = default_dungeon_spawns + randi_range(-1, 1)
	# 2+ as we need 1 Trapdoor-Room and 1 spawn-room
	print("posis")
	var positions = PosHelper.generate_random_positions(2 + inner_anvil_spawns + dungeon_spawns, Vector2i(level_width, level_height), inner_spawn_range, min_spawn_distance)
	
	var trapdoor_pos = positions[randi_range(0,positions.size()-1)]
	positions.erase(trapdoor_pos)
	
	print("special")
	map.special_ground = PosHelper.generate_points_with_increasing_density(level_width, level_height, trapdoor_pos, special_ground_amount)
	print("end special "+str(map.special_ground.size()))
	
	print("bound")
	generate_boundaries(map, ground_layer, block_layer, ground_atlas, block_atlas)
	print("general")
	generate_caves_and_ore(map, ground_layer, block_layer, ground_atlas, block_atlas)
	
	# Spawn TrapdoorRoom
	StructurePlacer.place_structure(StructureRegistry.Structures.get("TRAPDOOR_B"+str(biome)), trapdoor_pos, map, ground_layer, block_layer, ground_atlas, block_atlas)
	
	# Spawn AnvilRooms
	positions = spawn_anvil_rooms(map, ground_layer, block_layer, ground_atlas, block_atlas, biome, positions)
	
	# Spawn dungeons
	var spawn_point = spawn_dungeons(map, ground_layer, block_layer, ground_atlas, block_atlas, biome, positions)
	StructurePlacer.place_structure(StructureRegistry.Structures.get("SPAWNROOM_B"+str(biome)), spawn_point, map, ground_layer, block_layer, ground_atlas, block_atlas)
	
	return spawn_point

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
				map.set_ground(Vector2i(starting_point_x+i,starting_point_y+j) ,2)
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
				map.set_ground(Vector2i(starting_point_x+i,starting_point_y+j), 1)
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
						map.set_ground(cur_cell, 0)
					else:
						# There is some type of Block (So BlockType.GROUND or BlockType.ORE) above
						# Need to make a wall AND ground without nav
						var above_cell := map.get_neighbor_cell(cur_cell,TileSet.CELL_NEIGHBOR_TOP_SIDE)
						var above_atlas_x := map.get_cell_atlas_coords(block_layer,above_cell).x
						map.set_cell(block_layer,cur_cell,block_atlas, Vector2i(above_atlas_x,1), 0)
						
						map.set_ground(cur_cell, 0)
				BlockType.BLOCK:
					var alt = 0
					if y == 0:
						# Special handling for top-row
						map.erase_cell(ground_layer, cur_cell)
					elif get_block_type(block_above) == BlockType.GROUND:
						# It's a Top-Block -> Needs special Hitbox (alt) and Ground
						alt = 1
						map.set_ground(cur_cell, 1)
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
						map.set_ground(cur_cell, 1)
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


static func spawn_anvil_rooms(map: TileMap,ground_layer :int, block_layer :int, ground_atlas :int, block_atlas :int, biome :int, pos_list :Array) -> Array:
	var field_size = Vector2i(level_width,level_height)
	
	# Corner-Rooms 0: Top-Left, 1: Top-Right, 2: Bottom-Right, 3: Bottom-Left
	var corner_1 = randi_range(0, 3)
	var corner_2 = randi_range(0, 3)
	while corner_1 == corner_2: corner_2 = randi_range(0, 3)
	var pos1 = PosHelper.get_corner_pos(corner_1, field_size, corner_anvil_range, 6)
	StructurePlacer.place_structure(StructureRegistry.Structures.get("ANVIL_B"+str(biome)), pos1, map, ground_layer, block_layer, ground_atlas, block_atlas)
	var pos2 = PosHelper.get_corner_pos(corner_2, field_size, corner_anvil_range, 6)
	StructurePlacer.place_structure(StructureRegistry.Structures.get("ANVIL_B"+str(biome)), pos2, map, ground_layer, block_layer, ground_atlas, block_atlas)
	
	# Anvilroom in the middle (random)
	var pos3 = pos_list[randi_range(0,pos_list.size()-1)]
	pos_list.erase(pos3)
	StructurePlacer.place_structure(StructureRegistry.Structures.get("ANVIL_B"+str(biome)), pos3, map, ground_layer, block_layer, ground_atlas, block_atlas)
	
	# Return array of pos to store them
	return pos_list


static func spawn_dungeons(map: TileMap,ground_layer :int, block_layer :int, ground_atlas :int, block_atlas :int, biome :int, pos_list :Array) -> Vector2i:
	# -1 to still have a spawn-point
	for i in range(pos_list.size()-1):
		var pos = pos_list[randi_range(0,pos_list.size()-1)]
		pos_list.erase(pos)
		var available_dungeons = StructureHelper.get_dungeons_for_biome(biome)
		var dungeon = StructureRegistry.Structures.get(available_dungeons[randi_range(0, available_dungeons.size()-1)])
		StructurePlacer.place_structure(dungeon, pos, map, ground_layer, block_layer, ground_atlas, block_atlas)
	
	return pos_list[0]
