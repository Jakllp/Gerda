extends Node

class_name PosHelper


## Get's a random pos in the inner_range of a field. If with_negative (default) the field will be around the 0 point
static func get_random_pos_inner_range(field_size :Vector2i, inner_range :float, with_negative :bool = true) -> Vector2i:
	var x_range = field_size.x * inner_range
	var y_range = field_size.y * inner_range
	if with_negative:
		return Vector2i(randi_range(x_range/-2, (x_range/2) - 1), randi_range(y_range/-2, (y_range/2) - 1))
	else:
		#TODO implement
		return Vector2i(1,1)


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
