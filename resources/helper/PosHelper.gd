extends Node

class_name PosHelper


## Get's a random pos in a range in the corner of the field.
## If with_negative (default) the field will be around the 0 point
## If no padding is specified, it could be right in the corner
static func get_corner_pos(corner_num :int, field_size :Vector2i, corner_range :float, padding :int = 0, with_negative :bool = true) -> Vector2i:
	var x_range = field_size.x * corner_range
	var y_range = field_size.y * corner_range
	var x = randi_range((field_size.x / 2) -x_range, field_size.x / 2) if with_negative else randi_range(field_size.x-x_range, field_size.x)
	var y = randi_range((field_size.y / 2) -y_range, field_size.y / 2) if with_negative else randi_range(field_size.y-y_range, field_size.y)
	
	var pos = Vector2i(x-padding,y-padding)
	
	# -1 bc of 0,0 existing
	match (corner_num):
		0:
			pos *= Vector2i(-1,-1)
		1:
			pos *= Vector2i(1,-1)
			pos -= Vector2i(1,0)
		2:
			pos -= Vector2i(1,1)
		3:
			pos *= Vector2i(-1,1)
			pos -= Vector2i(0,1)
		_:
			pass
	return pos


## Generates a Map of amount-points inside inner-range-percent of the field that should be away from each other
## Radius defines the minimum distance between the points. Is 10 per default
## If with_negative (default) the field will be around the 0 point
static func generate_random_positions(amount :int, field_size :Vector2i, inner_range :float, radius := 10, with_negative :bool = true) -> Array:
	var new_field := Vector2i(field_size.x * inner_range, field_size.y * inner_range)
	var cell_size = radius / sqrt(2)
	var grid = []
	var output = []
	var active_list =  []

	var cells_x = int(new_field.x / cell_size) + 1
	var cells_y = int(new_field.y / cell_size) + 1
	
	# Initialize the grid
	for x in range(cells_x):
		var row = []
		for y in range(cells_y):
			row.append(-1)
		grid.append(row)
	
	# First point
	var first_point = Vector2i(randi_range(0, new_field.x), randi_range(0, new_field.y))
	var first_grid_x = int(first_point.x / cell_size)
	var first_grid_y = int(first_point.y / cell_size)
	grid[first_grid_x][first_grid_y] = output.size()
	output.append(first_point)
	active_list.append(first_point)
	
	# Generate additional points
	while active_list.size() > 0 and output.size() < amount:
		var random_index = randi() % active_list.size()
		var sample = active_list[random_index]
		
		var found_valid_point = false
		# 30 -> max_attempts
		for ign in range(30):
			var valid_point = generate_random_point_around(sample, radius)
			var valid_grid_x = int(valid_point.x / cell_size)
			var valid_grid_y = int(valid_point.y / cell_size)
			
			var is_valid = true
			var start_grid_x = max(0, valid_grid_x - 2)
			var end_grid_x = min(cells_x - 1, valid_grid_x + 2)
			var start_grid_y = max(0, valid_grid_y - 2)
			var end_grid_y = min(cells_y - 1, valid_grid_y + 2)
			
			for x in range(start_grid_x, end_grid_x + 1):
				for y in range(start_grid_y, end_grid_y + 1):
					var neighbor_index = grid[x][y]
					if neighbor_index != -1:
						var neighbor = output[neighbor_index]
						var distance = Vector2(valid_point).distance_to(Vector2(neighbor))
						if distance < radius:
							is_valid = false
							break
				if not is_valid:
					break

			if is_valid and point_in_range(valid_point, new_field):
				found_valid_point = true
				grid[valid_grid_x][valid_grid_y] = output.size()
				output.append(valid_point)
				active_list.append(valid_point)
				break

		if not found_valid_point:
			active_list.erase(random_index)
	
	for i in range(output.size()):
		if with_negative:
			output[i] -= Vector2i(new_field.x/2, new_field.y/2)
		else:
			var padding_x = (field_size.x - new_field.x) / 2
			var padding_y = (field_size.y - new_field.y) / 2
			output[i] += Vector2i(padding_x, padding_y)
	
	return output

static func generate_random_point_around(center: Vector2i, radius) -> Vector2i:
	# Generate a random point within a ring around the center
	var angle = randf() * 2 * PI
	var distance = randf() * radius + radius
	var offset_x = cos(angle) * distance
	var offset_y = sin(angle) * distance
	return center + Vector2i(offset_x, offset_y)


static func point_in_range(point :Vector2i, range :Vector2i) -> bool:
	if point.x >= 0 and point.x < range.x and point.y >= 0 and point.y < range.y:
		return true
	return false
