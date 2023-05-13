extends TileMap


# Damage-Map -> Stores the remaining hardness of cells
var remaining_hardness_dict = {}

# Set's the layers
var ground_layer := 0
var minable_layer := 1
var mine_overlay_layer := 2

# The mine-overlay-atlas
var mine_overlay_atlas := 1
# The current's biomes atlassssss
var block_atlas := 0
var ground_atlas := 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Logic of damaging cells
func damage_cell(cell: Vector2i, damage: float) -> void:
		if remaining_hardness_dict.has(cell):
			# We know the cell -> Further reduce damage
			remaining_hardness_dict[cell] = remaining_hardness_dict[cell] - damage
		else:
			# Unknown cell -> New Entry
			remaining_hardness_dict[cell] = self.get_cell_tile_data(minable_layer, cell).get_custom_data("hardness") - damage
		self.mine_overlay(cell)
		# Remove the tile when done
		if remaining_hardness_dict[cell] < 0:
			self.clear_cell(cell)


# Puts an overlay on the specified cell
func mine_overlay(cell: Vector2i) -> void:
	var percent = 1 - remaining_hardness_dict[cell] / self.get_cell_tile_data(minable_layer, cell).get_custom_data("hardness")
	if percent < 0.25:
		self.set_cell(mine_overlay_layer,cell,mine_overlay_atlas, Vector2i(0,0), 0)
		return
	if percent < 0.5:
		self.set_cell(mine_overlay_layer,cell,mine_overlay_atlas, Vector2i(1,0), 0)
		return
	if percent < 0.75:
		self.set_cell(mine_overlay_layer,cell,mine_overlay_atlas, Vector2i(2,0), 0)
		return
	if percent < 1:
		self.set_cell(mine_overlay_layer,cell,mine_overlay_atlas, Vector2i(3,0), 0)
		return


# Clears the cell - TODO also implement stuff like setting it to wall etc
func clear_cell(cell: Vector2i) -> void:
	self.erase_cell(mine_overlay_layer, cell)
	remaining_hardness_dict.erase(cell)
	self.erase_cell(minable_layer, cell)
	self.set_cell(ground_layer, cell, 2, Vector2i(0,0), 0)
