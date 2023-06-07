class_name ShapeHandler

static func get_shape_radius(shape: Shape2D) -> float:
	match shape:
		CircleShape2D, CapsuleShape2D:
			return shape.radius
		RectangleShape2D:
			return shape.size.length
		_:
			return 0
