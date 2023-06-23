extends TileMap

var pos := Vector2(425, 275)
@onready var cam: Camera2D = get_parent().get_node("Mole/Camera2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		var center: Vector2
		var local_pos = cam.to_local(pos)
		print(local_pos)
		local_pos *= cam.zoom
		print(local_pos)
		local_pos += get_viewport_rect().size / 2
		print(local_pos)
		
		print(get_viewport_rect().size)
		center.x = local_pos.x / get_viewport_rect().size.x
		center.y = local_pos.y / get_viewport_rect().size.y
		print(center)
		print()
		get_viewport()
		
		$CanvasLayer/ColorRect.material.set_shader_parameter("center", center)
