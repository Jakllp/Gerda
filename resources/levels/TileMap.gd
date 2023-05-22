extends TileMap


@export var ore_text_scene = preload("res://resources/other/ore_text.tscn")

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


# Logic of damaging cells
func damage_cell(cell: Vector2i, damage: float):
	var was_ore = false
	
	if remaining_hardness_dict.has(cell):
		# We know the cell -> Further reduce damage
		remaining_hardness_dict[cell] = remaining_hardness_dict[cell] - damage
	else:
		# Unknown cell -> New Entry
		remaining_hardness_dict[cell] = self.get_cell_tile_data(block_layer, cell).get_custom_data("hardness") - damage
	self.mine_overlay(cell)
	
	var attached_cell = null
	var cell_was_top :bool
	# Gotta check if cell itself is a wall
	if self.get_cell_atlas_coords(block_layer,cell,false).y == 1:
		attached_cell = self.get_neighbor_cell(cell,TileSet.CELL_NEIGHBOR_TOP_SIDE)
		cell_was_top = false
	# Same goes for it being the top of a wall
	elif self.get_cell_atlas_coords(block_layer,self.get_neighbor_cell(cell,TileSet.CELL_NEIGHBOR_BOTTOM_SIDE),false).y == 1:
		attached_cell = self.get_neighbor_cell(cell,TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
		cell_was_top = true
	else:
		cell_was_top = true
	if attached_cell != null:
		remaining_hardness_dict[attached_cell] = remaining_hardness_dict[cell]
		self.mine_overlay(attached_cell)
	
	# Remove the tile when it's destroyed
	if remaining_hardness_dict[cell] < 0:
		if self.get_cell_tile_data(block_layer, cell).get_custom_data("is_ore"):
			if cell_was_top:
				was_ore = cell
			else: 
				was_ore = attached_cell
		self.clear_cell(cell, attached_cell)
	return was_ore


# Puts an overlay on the specified cell
func mine_overlay(cell: Vector2i) -> void:
	# Sometimes this function get's called out of sync...
	if(self.get_cell_tile_data(block_layer, cell) == null):
			return
	
	var origin_atlas_y = self.get_cell_atlas_coords(block_layer,cell,false).y
	var percent = 1 - remaining_hardness_dict[cell] / self.get_cell_tile_data(block_layer, cell).get_custom_data("hardness")
	if percent < 0.25:
		self.set_cell(mine_overlay_layer,cell,mine_overlay_atlas, Vector2i(0,origin_atlas_y), 0)
	elif percent < 0.5:
		self.set_cell(mine_overlay_layer,cell,mine_overlay_atlas, Vector2i(1,origin_atlas_y), 0)
	elif percent < 0.75:
		self.set_cell(mine_overlay_layer,cell,mine_overlay_atlas, Vector2i(2,origin_atlas_y), 0)
	elif percent < 1:
		self.set_cell(mine_overlay_layer,cell,mine_overlay_atlas, Vector2i(3,origin_atlas_y), 0)


# Clears the cell - TODO NAV-UPDATES
func clear_cell(cell: Vector2i, attached_cell) -> void:
	# TODO Nav-updates!
	# The cell above the current cell AND an attached_cell if present
	var cell_above_everything :Vector2i
	# Cell that has a top-texture
	var top_cell :Vector2i
	# If it's just a random Block
	if(attached_cell == null):
		cell_above_everything = self.get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_TOP_SIDE)
		top_cell = cell
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
		self.set_cell(ground_layer, wall_cell, ground_atlas,Vector2i(0,0), 0)
		
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
				mine_overlay(top_cell)
			else:
				self.erase_cell(mine_overlay_layer, top_cell)
				remaining_hardness_dict.erase(top_cell)
			
			self.set_cell(ground_layer, cell, ground_atlas,Vector2i(0,0), 0)
			return
	
	# Nothing/wall on top of it -> delete it
	self.erase_cell(mine_overlay_layer, top_cell)
	remaining_hardness_dict.erase(top_cell)
	self.erase_cell(block_layer, top_cell)
	self.set_cell(ground_layer, top_cell, ground_atlas, Vector2i(0,0), 0)


# Handles the pop-up when the player receives ore
func _on_player_ore_received(amount: int, pos: Vector2) -> void:
	var ore_text := ore_text_scene.instantiate()
	ore_text.get_child(0,false).set_text("+"+str(amount))
	ore_text.global_position = pos
	owner.add_child(ore_text)
