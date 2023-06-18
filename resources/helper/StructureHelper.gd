extends Object


class_name StructureHelper


## Get's the pattern of a specific layer of a specific structure
static func get_structure_pattern(structure_name, layer :int) -> TileMapPattern:
	var map = StructureRegistry.get_map_for_structure(structure_name)
	if map == null: return null
	
	var range = StructureRegistry.get_pattern_range(structure_name)
	return map.get_pattern(layer, get_coord_array(Vector2i(-4,-4),Vector2i(4,4), map, layer))


## Returns an array of all on-tile things in a structure
static func get_static_things(structure_name, node_name :String):
	var map = StructureRegistry.get_map_for_structure(structure_name)
	var array = []
	for thing in map.get_node(node_name).get_children():
		array.append([load(thing.scene_file_path), map.local_to_map(thing.position)])
	return array


## Returns an array of all off-tile things in a structure
static func get_non_static_things(structure_name, node_name :String):
	var map = StructureRegistry.get_map_for_structure(structure_name)
	var array = []
	for thing in map.get_node(node_name).get_children():
		array.append([load(thing.scene_file_path), thing.position])
	return array


static func get_dungeons_for_biome(biome :int):
	var array = []
	for val in StructureRegistry.Dungeons.keys():
		if val.ends_with(str(biome)): array.append(val)
	return array

# From here on: Only used internally

static func get_coord_array(top_left :Vector2i, bottom_right :Vector2i, map :TileMap, layer :int):
	var array = []
	for y in range(abs(top_left.y)+abs(bottom_right.y) + 1):
		for x in range(abs(top_left.x)+abs(bottom_right.x) + 1):
			var cur_pos = Vector2i(top_left.x + x, top_left.y + y)
			if map.get_cell_source_id(layer, cur_pos) != -1:
				array.append(cur_pos)
	return array
