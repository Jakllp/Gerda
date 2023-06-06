extends Area2D

class_name Item

enum Item_Type {
	ORE,
	HEALTH
}

var rng = RandomNumberGenerator.new()
@export var min_ore_from_ore :int
@export var max_ore_from_ore :int

var type


func _ready() -> void:
	self.type = Item_Type.ORE
	
	skin_item()
	

func skin_item() -> void:
	match self.type:
		Item_Type.ORE:
			$Sprite2D.frame = 3
		Item_Type.HEALTH:
			$Sprite2D.frame = 0
		_:
			pass


# Player is on the item
func _on_body_entered(body :Node2D):
	print("ENTERED")
	if body is Player:
		var player :Player = body
		print("PLAYER ENTERED")
		match self.type:
			# Handle what the Item actually does
			Item_Type.ORE:
				var ore_amount := rng.randi_range(min_ore_from_ore, max_ore_from_ore)
				player.ore_pouch += ore_amount
				queue_free()
			Item_Type.HEALTH:
				pass
			_:
				pass
