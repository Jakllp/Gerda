extends StaticBody2D

class_name Chest

@export var item_scene :PackedScene


var open := false


func do_interaction() -> void:
	if not open:
		# Open the chest - simple enough
		open = true
		$Sprite2D.frame = 1
		drop_item()


func drop_item() -> void:
	var item = item_scene.instantiate()
	item.global_position = position + Vector2(0.0,15.0)
	owner.add_child(item)
