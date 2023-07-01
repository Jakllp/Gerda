extends Object
class_name ItemCreator

static func create_chest_item() -> Item:
	return create_item(Items.chest_drop_table)
	

static func create_boss_item() -> Item:
	return create_item(Items.boss_drop_table)
	

static func create_enemy_drop_item() -> Item:
	return create_item(Items.enemy_drop_table)


static func create_item(table) -> Item:
	var item: Item = preload("res://resources/interactables/Item.tscn").instantiate()
	var type := Items.roll_table(table)
	
	item.type = type.x
	item.item_data = type.y
	
	return item
