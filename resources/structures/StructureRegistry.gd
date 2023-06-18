extends Node

class_name StructureRegistry


# Not using dictionaries as we want some naming. Basically our own dictionaries.
# Otherwise we'd have dictionaries AND enums
enum Structures {
	TRAPDOOR_B1,
	ANVIL_B1,
	DUNGEON_1_B1
}


static func get_map_for_structure(structure_name) -> TileMap:
	match (structure_name):
		Structures.TRAPDOOR_B1:
			return preload("res://resources/structures/biome1/TrapdoorRoom.tscn").instantiate().get_node(".")
		Structures.ANVIL_B1:
			return preload("res://resources/structures/biome1/AnvilRoom.tscn").instantiate().get_node(".")
		Structures.DUNGEON_1_B1:
			return preload("res://resources/structures/biome1/BasicDungeon.tscn").instantiate().get_node(".")
		_:
			return null


static func get_pattern_range(structure_name):
	match (structure_name):
		Structures.TRAPDOOR_B1:
			return [Vector2i(-4,-4),Vector2i(4,4)]
		Structures.ANVIL_B1:
			return [Vector2i(-1,-1),Vector2i(1,1)]
		Structures.DUNGEON_1_B1:
			return [Vector2i(-1,-1),Vector2i(1,1)]
		_:
			return null


## Returns the ground_offset of a given pattern aka how much you have to move the ground_pattern for it to align with the block_pattern
static func get_ground_offset(structure_name) -> Vector2i:
	match (structure_name):
		# Only need to point to special cases, default is 0,0
		_:
			return Vector2i(0,0)
