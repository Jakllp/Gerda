extends Node

class_name MiningComponent

var currentCell :Vector2i
var currentMap :TileMap = null
var remainingHardness :float
# Aka how many damage it deals per second
var miningSpeed = 10

var shouldClear = true

func update(player: Player) -> void:
	if shouldClear and currentMap != null:
		clearCell(currentCell, currentMap, true)
	if not shouldClear:
		shouldClear = true

func mine(delta: float, collision: RayCast2D) -> bool:
	if collision.is_colliding() and collision.get_collider() is TileMap:
		var damage = delta * miningSpeed
		shouldClear = false
		
		# Get map and point
		var point := collision.get_collision_point()
		print("point" + str(point))
		var map :TileMap = collision.get_collider()
		var scale := map.scale
		print("scale: " + str(scale))
		point /= map.scale

		var normal = collision.get_collision_normal()
		print("normal: " + str(normal))
		point -= normal
		print("point modified: " + str(point))

		# Convert to actual tilemap-point
		var cell = map.local_to_map(point)
		print(cell)
		print("\n")
		
		#Sometimes this update and the cell breaking don't align properly
		if(map.get_cell_tile_data(1, cell) == null):
			return false
		
		var cellHardness = map.get_cell_tile_data(1, cell).get_custom_data("hardness")
		
		# Actually mine (aka reduce health of that point)
		if cell != currentCell or currentMap == null:
			# Remove other cell if direct connect
			if currentMap != null:
				clearCell(currentCell,currentMap, true)
			
			currentCell = cell
			currentMap = map
			var data = map.get_cell_tile_data(1, cell)
			remainingHardness = cellHardness - damage
		else:
			remainingHardness -= damage
		mineOverlay(cell,map,cellHardness)
		# Remove the tile when done
		if remainingHardness < 0:
			clearCell(cell, map, false)
		return true
	return false

func mineOverlay(cell: Vector2i, map: TileMap, cellHardness: int) -> void:
	map.set_cell(2,cell,0, Vector2i(10,1), 0)
	print(cellHardness)
	print(remainingHardness)
	print(cellHardness/remainingHardness)
	var redEffect :float = 0.5 - (remainingHardness / cellHardness)
	print("redEffect: " + str(redEffect))

	map.set_layer_modulate(2,Color(1.0,0.0,0.0,redEffect))
	
func clearCell(cell: Vector2i, map: TileMap, onlyOverlay: bool) -> void:
	map.erase_cell(2, cell)
	remainingHardness = 0.0
	currentMap = null
	if not onlyOverlay:
		map.erase_cell(1, cell)
		map.set_cell(0, cell, 0, Vector2i(0,0), 0)
