class_name ShapeHelper

static func get_shape_radius(shape: Shape2D) -> float:
	if shape is CircleShape2D or shape is CapsuleShape2D:
		return shape.radius
	elif shape is RectangleShape2D:
		return shape.size.length()
	else:
		return 0


static func get_enclosing_box_size(shape: Shape2D) -> Vector2:
	if shape is CircleShape2D:
		return Vector2(shape.radius * 2, shape.radius * 2)
	elif shape is CapsuleShape2D:
		return Vector2(shape.radius * 2, shape.height)
	elif shape is RectangleShape2D:
		return shape.size
	else:
		return Vector2.ZERO
