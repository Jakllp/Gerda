extends Area2D

class_name Item

var type: Items.Type
var item_data = null


func _ready() -> void:
	add_child(Items.get_item_sprite(type))

# Player is on the item
func _on_body_entered(body :Node2D):
	if body is Player and item_data != null:
		var player :Player = body
		
	# Handle what the Item actually does
		if Items.upgrade_category["player"].has(type):
			player.add_upgrade(type)
		elif Items.upgrade_category["weapon"].has(type):
			player.weapon.add_upgrade(type)
		elif type == Items.Type.ORE:
			player.ore_pouch += item_data
		elif type == Items.Type.HEALTH:
				#TODO what if it no work?
				player.add_health(item_data)
		elif type == Items.Type.HEART:
				player.get_node("HealthComponent").hp_max += item_data
		elif type == Items.Type.DASH:
				player.dash_max_amount += item_data
		
		queue_free()
		
