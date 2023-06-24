extends Object

class_name ItemCreator

# Values for creation
const min_ore_from_item = 1
const max_ore_from_item = 4

static func create_chest_item() -> Item:
	var item: Item = preload("res://resources/interactables/Item.tscn").instantiate()
	var type := Items.roll_root_table()
	
	item.type = type.x
	item.item_data = type.y
	
	return item
	

static func create_boss_item() -> Item:
	var item: Item = preload("res://resources/interactables/Item.tscn").instantiate()
	var type := Items.roll_table(Items.boss_drop_table)
	
	item.type = type.x
	item.item_data = type.y
	
	return item
