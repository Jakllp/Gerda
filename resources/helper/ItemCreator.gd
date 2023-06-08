extends Node

class_name ItemCreator

# Values for creation
const min_ore_from_item = 1
const max_ore_from_item = 4

static func create_chest_item(item):
	#TODO - Proper probabilities
	var rng = RandomNumberGenerator.new()
	var wanted_type = rng.randi_range(0,Item.Item_Type.values().size()-1)
	var wanted_item_data
	match wanted_type:
		Item.Item_Type.ORE:
			wanted_item_data = rng.randi_range(min_ore_from_item, max_ore_from_item)
		Item.Item_Type.HEALTH:
			wanted_item_data = 10
		Item.Item_Type.PLAYER_UPGRADE:
			wanted_item_data = rng.randi_range(0,Upgrade.Player_Upgrade.values().size()-1)
		Item.Item_Type.WEAPON_UPGRADE:
			wanted_item_data = rng.randi_range(0,Upgrade.Weapon_Upgrade.values().size()-1)
		_:
			pass
	item.init(wanted_type, wanted_item_data)
