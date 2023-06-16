class_name ShapeHelper

static func get_shape_radius(shape: Shape2D) -> float:
	if shape is CircleShape2D or shape is CapsuleShape2D:
		return shape.radius
	elif shape is RectangleShape2D:
		return shape.size.length()
	else:
		return 1
