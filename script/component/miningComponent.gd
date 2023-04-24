extends Node

class_name MiningComponent

func mine() -> void:
	pass

#	wage idea/direction how mining could be done from the erly tests

#func _unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed("LMB"):
#		get_viewport().set_input_as_handled()
#		var collision :RayCast2D = $RayCast2D
#		print("Colliding with: " + str(collision.get_collider()))
#		if collision.is_colliding() and collision.get_collider() is TileMap:
#			var point := collision.get_collision_point()
#			print("point" + str(point))
#			var map :TileMap = collision.get_collider()
#
#			var scale := map.scale
#			print("scale: " + str(scale))
#			point /= map.scale
#
#			var normal = collision.get_collision_normal()
#			print("normal: " + str(normal))
#			point -= normal
#
#			print("point modified: " + str(point))
#
#			var point2 = map.local_to_map(point)
#			print(point2)
#			print("\n")
#			map.erase_cell(1, point2)
#			map.set_cell(0, point2, 0, Vector2i(0,0), 0)
