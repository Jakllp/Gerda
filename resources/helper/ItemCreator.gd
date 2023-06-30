extends Object
class_name ItemCreator


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
