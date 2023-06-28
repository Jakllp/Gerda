extends Node
## extends Node cause for what reason ever this is the only way to make this class an autoload.

## *************************************************************************************************************************************************************
## ***********************************************************************   IMPORTANT   ***********************************************************************
## ************************************************************   READ THIS BEFORE USING ANYTHING   ************************************************************
## *************************************************************************************************************************************************************
##
## In the enum 'Type' are all existing Items listed. Furthermore, every item type is listed in a loot table with its corresponding rarity weight.
## The higher the weight the more likely it is to draw this item. Normal loot tables may be nested and can contain other loot tables marked with a rarity weight.
## There is the 'root_table' which is supposed to contain every item type at least once.
##
## Currently there are 3 different loot table types:
##
##		1.	Normal loot table -> Dictionary:
##				 A Dictionary with the rarity weight as value. Keys can be item types (the enum value) or oter loot tables.
##
##		2. Normal distributed range table -> Vector3i:
##				Choose this loot table type for an item type if you want the item to be of a equal random quantity. So this table represents only one item type but different quantities of it.
##				A table of this type has to be in the form of Vector3i(Type, min_value, max_value). Type is the enum value of the item type. min_value and max_value represent 
##				the range of possible quantity (both inclusive). Every value in the specified range has each time the same chance to be drawn. 
##				For example you want Type.ORE to be of random quanitiy in the range of 1 and 4 then you would define the ore_table as Vector3i(Type.Ore, 1, 4).
##
##		3. Weighted range table -> Array:
##				This table type is like the 'Normal distributed range table' supposed to represent only one item but different quantities of it. The difference is that here you can specify 
##				the weight for each quantity. A table of this type has to be of the form [Type, Vector2i(quantity1, weight), Vector2i(quantity2, weight), ...].
##				For example you want a 50% chance to get 2 of Type.ORE and 25% chance for 3 and for than you would define the ore_table as
##				[Type.ORE, Vector2i(2, 2), Vector2i(3, 1), Vector2i(4, 1)]
##
## To get an item from a table use the roll_table(table) method. Possibly nested tables are evaluated recursively. To roll from the root table you can easily use the 
## roll_root_table(table) method.
## To add a new item make an entry in the 'Type' enum and either add it to an existing loot table or create a new. When creating a new one make sure to add it somewhere in the hirarchy
## of the root table or make make sure you have a good reason not to. And make sure to create them in the correct order. If you create a new table that depends on another table
## the new one needs to be defined beneath the one it depends on. Additionally when adding a new player or weapon upgrade you need to add it in the corresponing category
## of the upgrade_category dictionary.


## All The Item types
enum Type {
	ORE,
	HEALTH,
	WALK_SPEED,
	DASH_COOLDOWN,
	MINING_SPEED,
	DAMAGE,
	ATTACK_RATE,
	WEAPON_SPEED, #Gun: ReloadSpeed, Melee: SwingSpeed
	HEART,
	DASH
}

var upgrade_category: Dictionary = {
	"player" : [Type.WALK_SPEED, Type.DASH_COOLDOWN, Type.MINING_SPEED],
	"weapon" : [Type.DAMAGE, Type.ATTACK_RATE, Type.WEAPON_SPEED]
}

## weighted range table
var health_table := [Type.HEALTH, Vector2(1,2), Vector2(2,1)]

## Normal distributed range table for ore
var ore_table := Vector3i(Type.ORE, 1, 4)

## Table with player upgrades
var player_upgrade_table: Dictionary = {
	Type.WALK_SPEED : 1,
	Type.DASH_COOLDOWN: 1,
	Type.MINING_SPEED : 1
}

## Table with weapon upgrades
var weapon_upgrade_table: Dictionary = {
	Type.DAMAGE : 1,
	Type.ATTACK_RATE : 1,
	Type.WEAPON_SPEED : 1
}

## Table with items droped by bosses
var boss_drop_table: Dictionary = {
	Type.HEART : 1,
	Type.DASH : 1
}

## Main entry point to all existing items
var root_table: Dictionary = {
		health_table : 3,
		ore_table : 3,
		player_upgrade_table: 2,
		weapon_upgrade_table : 2,
		boss_drop_table : 0
	}


## Selects a Random Item from the root table.
## Return value is of form Vector2i(Type, quantity)
func roll_root_table() -> Vector2i:
	return roll_table(root_table)

## Selects a Random Item from the given table.
## Return value is of form Vector2i(Type, quantity)
func roll_table(table) -> Vector2i:
	if table is Vector3i:
		return roll_normal_distributed_range_table(table)
	elif table is Array:
		return roll_weighted_range_table(table)
	
	assert(table is Dictionary, "Can't select item from unkown table type: "+str(table))
	var result
	var rand_value = randi_range(0, get_total_weight(table) - 1)
	for key in table.keys():
		rand_value -= table[key]
		if rand_value < 0:
			result = key
			break
	
	assert(result != null, "Something bad happend! Total sum of weights could have been to small. Then the error would be in the get_total_weight() method. Could be something else as well though idk")
	
	if result is Dictionary or result is Vector3i or result is Array:
		return roll_table(result)
	else:
		assert(result is int and result >=0 and result < Type.size(), "invalid value for loot table. Key was no known item type")
		return Vector2i(result, 1)
	

## Select random quantity for the given type in the vector
## The vector has to be of the form Vector3i(Type, min_value, max_value).
## min_value and max_value are both inclusive
func roll_normal_distributed_range_table(table: Vector3i) -> Vector2i:
	assert(table.x is int and table.x >=0 and table.x < Type.size(), "invalid 'Type' value for normal distributed range table. Expected 'int' in range [0,"+str(Type.size())+"] but was '"+str(table.x))
	return Vector2i(table.x, randi_range(table.y, table.z))
	

## Select a random quantity for the given 'Type' in the array
## The array has to be of the form [Type, Vector2i(quantity1, weight), Vector2i(quantity2, weight), ...]
func roll_weighted_range_table(table: Array) -> Vector2i:
	assert(table[0] is int and table[0] >=0 and table[0] < Type.size(), "invalid 'Type' value for weighted range table. Expected 'int' in range [0,"+str(Type.size())+"] but was '"+str(table[0]))
	var rand_value = randi_range(0, get_total_weight(table) - 1)
	var result
	
	for i in range(1, table.size()):
		assert(table[i] is Vector2i, "invalid value for weighted range table. Expected 'Vector2i' to specify the weight of the quantity but was '"+str(table[i])+"'")
		rand_value -= table[i].y
		if rand_value < 0:
			result = table[i].x
	
	return Vector2i(table[0], result)
	

## Calculates the total weight of the given table
func get_total_weight(table) -> int:
	assert(table is Array or table is Dictionary, "Can't calculate total weight of unkown table")
	var sum: int = 0
	if table is Dictionary:
		for value in table.values():
			assert(value is int, "invalid type for table weight. Expected 'int' but was '"+str(value)+"'")
			sum += value
			
	elif table is Array:
		for i in range(1, table.size()):
			assert(table[i] is Vector2i, "invalid value for weighted range table. Expected 'Vector2i' to specify the weight of the quantity but was '"+str(table[i])+"'")
			sum += table[i].y
	
	return sum
	

var hud_item_tex = preload("res://asset/visual/UI/HUD_Elements.png")
var boss_item_tex = preload("res://asset/visual/other/BossDrops.png")
## creates the sprite for the given item type
func get_item_sprite(type: Type, quantity: int = 0) -> Sprite2D:
	var texture := AtlasTexture.new()
	if type < Type.HEART:
		texture.atlas = hud_item_tex
	else:
		texture.atlas = boss_item_tex
	
	match type:
		Type.ORE:
			texture.region.position = Vector2(24,0)
			texture.region.size = Vector2(8,8)
		Type.HEALTH:
			if quantity == 1:
				texture.region.position = Vector2(0,8)
				texture.region.size = Vector2(8,8)
			if quantity == 2:
				texture.region.position = Vector2(0,0)
				texture.region.size = Vector2(8,8)
		Type.WALK_SPEED:
			texture.region.position = Vector2(16,8)
			texture.region.size = Vector2(8,8)
		Type.DASH_COOLDOWN:
			texture.region.position = Vector2(16,16)
			texture.region.size = Vector2(8,8)
		Type.MINING_SPEED:
			texture.region.position = Vector2(16,0)
			texture.region.size = Vector2(8,8)
		Type.DAMAGE:
			texture.region.position = Vector2(8,8)
			texture.region.size = Vector2(8,8)
		Type.ATTACK_RATE:
			texture.region.position = Vector2(8,16)
			texture.region.size = Vector2(8,8)
		Type.WEAPON_SPEED:
			texture.region.position = Vector2(8,0)
			texture.region.size = Vector2(8,8)
		Type.HEART:
			texture.region.position = Vector2(0,0)
			texture.region.size = Vector2(8,8)
		Type.DASH:
			texture.region.position = Vector2(8,0)
			texture.region.size = Vector2(8,8)
		
	var sprite := Sprite2D.new()
	sprite.texture = texture
	return sprite
