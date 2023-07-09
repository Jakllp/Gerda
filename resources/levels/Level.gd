extends TileMap
class_name Level

var ore_text_scene = preload("res://resources/other/OreText.tscn")

# Damage-Map -> Stores the remaining hardness of cells
var remaining_hardness_dict = {}

# The layers
var ground_layer := 0
var block_layer := 1
var mine_overlay_layer := 2

# The mine-overlay-atlas
var mine_overlay_atlas := 1
# The current's biomes atlassssss
var block_atlas := 0
var ground_atlas := 2

## Stores the dict with all points that need special ground
var special_ground :Dictionary
var player_spawn


func _ready() -> void:
	# Add Mutators here for testing
	#MutatorManager.add_mutator(Mutator.new(Mutator.MutatorType.SPEED_UP, 2))
	var player :Player = get_tree().get_first_node_in_group("player")
	player.position = self.map_to_local(player_spawn)
	player.ore_received.connect(_on_player_ore_received)
	var camera = player.get_node("Camera2D")
	if not camera.is_current():
		camera.make_current()


func generate(biome: GameWorld.Biome) -> void:
	print("start god")
	print("generate biome: ", biome)
	player_spawn = God.generate_level(self, ground_layer, block_layer, block_atlas, biome)
	print("end god")


# Logic of damaging cells
func damage_cell(cell: Vector2i, damage: float) -> bool:
	if remaining_hardness_dict.has(cell):
		# We know the cell -> Further reduce damage
		remaining_hardness_dict[cell] = remaining_hardness_dict[cell] - damage
	else:
		# Unknown cell -> New Entry
		remaining_hardness_dict[cell] = self.get_cell_tile_data(block_layer, cell).get_custom_data("hardness") * MutatorManager.get_modifier_for_type(Mutator.MutatorType.HARDENED_STONE) - damage
	self.mine_overlay(cell)
	
	var attached_cell = null
	# Gotta check if cell itself is a wall
	if self.get_cell_atlas_coords(block_layer,cell,false).y == 1:
		attached_cell = self.get_neighbor_cell(cell,TileSet.CELL_NEIGHBOR_TOP_SIDE)
	# Same goes for it being the top of a wall
	elif self.get_cell_atlas_coords(block_layer,self.get_neighbor_cell(cell,TileSet.CELL_NEIGHBOR_BOTTOM_SIDE),false).y == 1:
		attached_cell = self.get_neighbor_cell(cell,TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
	
	if attached_cell != null:
		remaining_hardness_dict[attached_cell] = remaining_hardness_dict[cell]
		self.mine_overlay(attached_cell)
	
	var was_ore :bool
	# Remove the tile when it's destroyed
	if remaining_hardness_dict[cell] < 0:
		was_ore = self.get_cell_tile_data(block_layer, cell).get_custom_data("is_ore")
		self.clear_cell(cell, attached_cell)
	return was_ore


# Puts an overlay on the specified cell
func mine_overlay(cell: Vector2i) -> void:
	# Sometimes this function get's called out of sync...
	if(self.get_cell_tile_data(block_layer, cell) == null):
			return
	
	var origin_atlas_y = self.get_cell_atlas_coords(block_layer,cell).y
	var percent = 1 - remaining_hardness_dict[cell] / (self.get_cell_tile_data(block_layer, cell).get_custom_data("hardness") * MutatorManager.get_modifier_for_type(Mutator.MutatorType.HARDENED_STONE))
	if percent < 0.25:
		if self.get_cell_source_id(mine_overlay_atlas, cell) != -1 and self.get_cell_atlas_coords(mine_overlay_layer,cell).x != 0:
			self.set_cell(mine_overlay_layer,cell,mine_overlay_atlas, Vector2i(0,origin_atlas_y), 0)
	elif percent < 0.5:
		if self.get_cell_source_id(mine_overlay_atlas, cell) != -1 and self.get_cell_atlas_coords(mine_overlay_layer,cell).x != 1:
			self.set_cell(mine_overlay_layer,cell,mine_overlay_atlas, Vector2i(1,origin_atlas_y), 0)
	elif percent < 0.75:
		if self.get_cell_source_id(mine_overlay_atlas, cell) != -1 and self.get_cell_atlas_coords(mine_overlay_layer,cell).x != 2:
			self.set_cell(mine_overlay_layer,cell,mine_overlay_atlas, Vector2i(2,origin_atlas_y), 0)
	elif percent < 1:
		if self.get_cell_source_id(mine_overlay_atlas, cell) != -1 and self.get_cell_atlas_coords(mine_overlay_layer,cell).x != 3:
			self.set_cell(mine_overlay_layer,cell,mine_overlay_atlas, Vector2i(3,origin_atlas_y), 0)


# Clears the cell
func clear_cell(cell: Vector2i, attached_cell) -> void:
	# The cell above the current cell AND an attached_cell if present
	var cell_above_everything :Vector2i
	# Cell that has a top-texture
	var top_cell :Vector2i
	# If it's just a random Block
	if(attached_cell == null):
		cell_above_everything = self.get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_TOP_SIDE)
		top_cell = cell
		var bottom_cell = self.get_neighbor_cell(cell,TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
		if self.get_cell_source_id(block_layer, bottom_cell, false) != -1:
			# Block below is now top if a wall -> update ground with a bit of navigation and adjust collision
			self.set_ground(bottom_cell, 1)
			var bottom_cell_atlas_coords = self.get_cell_atlas_coords(block_layer, bottom_cell, false)
			self.set_cell(block_layer, bottom_cell, block_atlas, bottom_cell_atlas_coords, 1)
	# We have a wall-block!
	else:
		var wall_cell :Vector2i
		if attached_cell.y > cell.y:
			top_cell = cell
			wall_cell = attached_cell
		else:
			top_cell = attached_cell
			wall_cell = cell
		
		# Handle Wall-Cell
		self.erase_cell(mine_overlay_layer, wall_cell)
		remaining_hardness_dict.erase(wall_cell)
		self.erase_cell(block_layer, wall_cell)
		# Ground underneath now gone wall -> Full Navigation
		self.set_ground(wall_cell, 0)
		
		cell_above_everything = self.get_neighbor_cell(top_cell, TileSet.CELL_NEIGHBOR_TOP_SIDE)
	
	# Handle Top-Cell aka make it a Wall IF there is another cell above it and it's NOT a wall
	if self.get_cell_source_id(block_layer, cell_above_everything, false) != -1:
		# There's something on top of it -> let's see if it is a top or a wall
		if self.get_cell_atlas_coords(block_layer,cell_above_everything,false).y == 0:
			# It's a top -> Gotta make a wall
			# Get the x-atlas-coords of the cell ABOVE the top_cell -> we need the correct wall
			var top_atlas_coords_x = self.get_cell_atlas_coords(block_layer,cell_above_everything,false).x
			self.set_cell(block_layer, top_cell, block_atlas,Vector2i(top_atlas_coords_x,1), 0)
			
			# Let's see if the block above is damaged and handle it accordingly
			if remaining_hardness_dict.has(cell_above_everything):
				remaining_hardness_dict[top_cell] = remaining_hardness_dict[cell_above_everything]
				# Need to erase to still work with performance improvements of mine_overlay()
				self.erase_cell(mine_overlay_layer, top_cell)
				mine_overlay(top_cell)
			else:
				self.erase_cell(mine_overlay_layer, top_cell)
				remaining_hardness_dict.erase(top_cell)
			# It is now a wall -> Update ground with a no navigation
			self.set_ground(top_cell, 2)
			return
	
	# Nothing/wall on top of it -> delete it
	self.erase_cell(mine_overlay_layer, top_cell)
	remaining_hardness_dict.erase(top_cell)
	self.erase_cell(block_layer, top_cell)
	self.set_ground(top_cell, 0)


## Sets the ground on a cell - with regard to special ground
func set_ground(cell :Vector2i, alt :int) -> void:
	if self.special_ground.has(cell):
		self.set_cell(ground_layer,cell,ground_atlas, Vector2i(1,0), alt)
	else:
		self.set_cell(ground_layer,cell,ground_atlas, Vector2i(0,0), alt)


# Handles the pop-up when the player receives ore
func _on_player_ore_received(amount: int, pos: Vector2) -> void:
	var ore_text := ore_text_scene.instantiate()
	ore_text.get_child(1,false).set_text("+"+str(amount))
	ore_text.global_position = pos
	get_tree().get_first_node_in_group("unshaded").add_child(ore_text)
