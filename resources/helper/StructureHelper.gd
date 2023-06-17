extends Object


class_name StructureHelper


# Not using dictionaries as we want some naming. Basically our own dictionaries.
# Otherwise we'd have dictionaries AND enums
enum General {
	TRAPDOOR_B1,
	ANVIL_B1
}

enum Dungeons {
	BASIC_DUNGEON_B1
}


## Get's the pattern of a specific layer of a specific structure
static func get_structure_pattern(structure_name, layer :int) -> TileMapPattern:
	var map = get_map_for_structure(structure_name)
	if map == null: return null
	
	match (structure_name):
		General.TRAPDOOR_B1:
			return map.get_pattern(layer, get_coord_array(Vector2i(-4,-5),Vector2i(4,3), map, layer))
		_:
			return null


## Returns the ground_offset of a given pattern aka how much you have to move the ground_pattern for it to align with the block_pattern
static func get_ground_offset(structure_name) -> Vector2i:
	match (structure_name):
		# Only need to point to special cases, default is 0,0
		_:
			return Vector2i(0,0)


## Returns an array of all on-tile things in a structure
static func get_static_things(structure_name, node_name :String):
	var map = get_map_for_structure(structure_name)
	var array = []
	for thing in map.get_node(node_name).get_children():
		array.append([load(thing.scene_file_path), map.local_to_map(thing.position)])
	return array


## Returns an array of all off-tile things in a structure
static func get_non_static_things(structure_name, node_name :String):
	var map = get_map_for_structure(structure_name)
	var array = []
	for thing in map.get_node(node_name).get_children():
		array.append([load(thing.scene_file_path), thing.position])
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


static func get_map_for_structure(structure_name) -> TileMap:
	match (structure_name):
		General.TRAPDOOR_B1:
			return preload("res://resources/structures/biome1/TrapdoorRoom.tscn").instantiate().get_node(".")
		_:
			return null
