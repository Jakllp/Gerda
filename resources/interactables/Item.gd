extends Area2D

class_name Item

var type: Items.Type
var item_data = null
var pop_up_scene = preload("res://resources/other/ItemPopUp.tscn")


func _ready() -> void:
	add_child(Items.get_item_sprite(type, item_data))


# Player is on the item
func _on_body_entered(body :Node2D):
	if body is Player and item_data != null:
		var player :Player = body
		var with_popup := true
		
		# Handle what the Item actually does
		if Items.upgrade_category["player"].has(type):
			player.add_upgrade(type)
		elif Items.upgrade_category["weapon"].has(type):
			player.weapon.add_upgrade(type)
		elif type == Items.Type.ORE:
			with_popup = false
			player.ore_pouch += item_data
		elif type == Items.Type.HEALTH:
			var helt_component = player.get_node("PlayerHealthComponent")
			if helt_component.hp == helt_component.hp_max: return
			helt_component.hp += item_data
		elif type == Items.Type.HEART:
			player.get_node("PlayerHealthComponent").hp_max += item_data
		elif type == Items.Type.DASH:
			player.dash_max_amount += item_data
		
		if with_popup:
			var pop_up := pop_up_scene.instantiate()
			pop_up.get_child(0,false).texture = self.get_child(1, false).texture
			var pos = player.position - Vector2(0,15)
			pop_up.global_position = pos
			get_node("/root/GameWorld/Unshaded").add_child(pop_up)
		
		queue_free()
