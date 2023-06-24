extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	$SpiderBoss.process_mode = Node.PROCESS_MODE_DISABLED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_closing_block_1_body_entered(body, is_first, is_last_one):
	var pos = local_to_map(body.global_position)
	set_cell(1, pos, 0, Vector2(2,0), 1)
	
	if is_first:
		set_cell(1, pos+Vector2i(0,1), 0, Vector2(2,1))
	
	if is_last_one:
		var player_cam = get_tree().get_first_node_in_group("player").get_node("Camera2D")
		player_cam.apply_noise_screen_shake()
		await player_cam.shake_finished
		$SpiderBoss.process_mode = Node.PROCESS_MODE_INHERIT
	
