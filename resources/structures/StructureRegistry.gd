extends Node


# Not using dictionaries as we want some naming. Basically our own dictionaries.
# Otherwise we'd have dictionaries AND enums
enum Structures {
	TRAPDOOR_B1,
	ANVIL_B1,
	DUNGEON_1_B1,
	DUNGEON_2_B1,
	DUNGEON_3_B1,
	SPAWNROOM_B1
}

var scene_for_biome1_structure := {
		Structures.TRAPDOOR_B1 : preload("res://resources/structures/biome1/TrapdoorRoom.tscn"),
		Structures.ANVIL_B1 : preload("res://resources/structures/biome1/AnvilRoom.tscn"),
		Structures.DUNGEON_1_B1 : preload("res://resources/structures/biome1/BasicDungeon.tscn"),
		Structures.DUNGEON_2_B1 : preload("res://resources/structures/biome1/Dungeon2.tscn"),
		Structures.DUNGEON_3_B1 : preload("res://resources/structures/biome1/Dungeon3.tscn"),
		Structures.SPAWNROOM_B1 : preload("res://resources/structures/biome1/SpawnRoom.tscn")
}

var structs_for_biome := {
	GameWorld.Biome.BIOME_1: scene_for_biome1_structure
}

var structures := {}

func init(biome: GameWorld.Biome) -> void:
	print("init structures for biome: ", biome)
	for struct_type in structs_for_biome[biome]:
		print("struct: ", Structures.keys()[struct_type])
		structures[struct_type] = structs_for_biome[biome][struct_type].instantiate().get_node(".")
		

func clear() -> void:
	for struct in structures:
		structures[struct].queue_free()
	structures.clear()
	print("structures cleared")

func get_map_for_structure(structure_name: Structures) -> TileMap:
	if structures.has(structure_name):
		return structures[structure_name]
	else:
		return null


func get_pattern_range(structure_name):
	match (structure_name):
		Structures.TRAPDOOR_B1:
			return [Vector2i(-5,-5),Vector2i(4,4)]
		Structures.ANVIL_B1:
			return [Vector2i(-2,-3),Vector2i(2,2)]
		Structures.DUNGEON_1_B1:
			return [Vector2i(-3,-3),Vector2i(3,2)]
		Structures.DUNGEON_2_B1:
			return [Vector2i(-3,-5),Vector2i(3,4)]
		Structures.DUNGEON_3_B1:
			return [Vector2i(-2,-2),Vector2i(2,2)]
		Structures.SPAWNROOM_B1:
			return [Vector2i(-1,-1),Vector2i(0,0)]
		_:
			return null


## Returns the ground_offset of a given pattern aka how much you have to move the ground_pattern for it to align with the block_pattern
func get_ground_offset(structure_name) -> Vector2i:
	match (structure_name):
		# Only need to point to special cases, default is 0,0
		_:
			return Vector2i(0,0)
