extends TileMap


func _ready():
	# Unfortunately only works this way
	$CanvasModulate.visible = false
	var tweeny = create_tween()
	tweeny.tween_property($CanvasModulate, "visible", true, 0.01)
