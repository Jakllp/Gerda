extends Area2D

class_name Item

enum Item_Type {
	ORE,
	HEALTH,
	PLAYER_UPGRADE,
	WEAPON_UPGRADE
}

var type
var item_data = null


# Constructor for an item
# Needs type, does not need item_data
func init(set_type:int, set_item_data):
	self.type = set_type
	self.item_data = set_item_data
	skin_item()
	

func skin_item() -> void:
	match self.type:
		Item_Type.ORE:
			$Sprite2D.frame = 3
		Item_Type.HEALTH:
			$Sprite2D.frame = 0
		Item_Type.PLAYER_UPGRADE:
			match self.item_data:
				Upgrade.Player_Upgrade.WALK_SPEED:
					$Sprite2D.frame = 2
				Upgrade.Player_Upgrade.DASH_COOLDOWN:
					$Sprite2D.frame = 6
				Upgrade.Player_Upgrade.MINING_SPEED:
					$Sprite2D.frame = 10
				_:
					pass
		Item_Type.WEAPON_UPGRADE:
			match self.item_data:
				Upgrade.Weapon_Upgrade.DAMAGE:
					$Sprite2D.frame = 1
				Upgrade.Weapon_Upgrade.RATE:
					$Sprite2D.frame = 5
				Upgrade.Weapon_Upgrade.SPEED:
					$Sprite2D.frame = 9
				_:
					pass
		_:
			pass


# Player is on the item
func _on_body_entered(body :Node2D):
	if body is Player and item_data != null:
		var player :Player = body
		match self.type:
			# Handle what the Item actually does
			Item_Type.ORE:
				player.ore_pouch += item_data
				queue_free()
			Item_Type.HEALTH:
				#TODO what if it no work?
				player.add_health(item_data)
				queue_free()
			Item_Type.PLAYER_UPGRADE:
				match self.item_data:
					Upgrade.Player_Upgrade.WALK_SPEED:
						player.active_upgrades["WALK_SPEED"] += 1
					Upgrade.Player_Upgrade.DASH_COOLDOWN:
						player.active_upgrades["DASH_COOLDOWN"] += 1
					Upgrade.Player_Upgrade.MINING_SPEED:
						player.active_upgrades["MINING_SPEED"] += 1
					_:
						pass
				queue_free()
			Item_Type.WEAPON_UPGRADE:
				match self.item_data:
					Upgrade.Weapon_Upgrade.DAMAGE:
						player.weapon.active_upgrades["DAMAGE"] += 1
					Upgrade.Weapon_Upgrade.RATE:
						player.weapon.active_upgrades["RATE"] += 1
					Upgrade.Weapon_Upgrade.SPEED:
						player.weapon.active_upgrades["SPEED"] += 1
					_:
						pass
				queue_free()
			_:
				pass
