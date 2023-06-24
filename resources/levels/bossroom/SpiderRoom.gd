extends TileMap

var trap_door_scene: PackedScene = preload("res://resources/interactables/Trapdoor.tscn")
@onready var trap_door_pos = $SpiderBoss.global_position


# Called when the node enters the scene tree for the first time.
func _ready():
	$SpiderBoss.process_mode = Node.PROCESS_MODE_DISABLED
	$SpiderBoss.died.connect(on_spider_boss_died)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func on_spider_boss_died() -> void:
	var trap_door = trap_door_scene.instantiate()
	trap_door.global_position = trap_door_pos
	add_child(trap_door)
	
	var boss_drop = ItemCreator.create_boss_item()
	boss_drop.global_position = trap_door_pos + Vector2(0, -30)
	
	var item1 = ItemCreator.create_chest_item()
	item1.global_position = trap_door_pos + Vector2(30, 0)
	
	var item2 = ItemCreator.create_chest_item()
	item2.global_position = trap_door_pos + Vector2(-30, 0)
	
	add_child(boss_drop)
	add_child(item1)
	add_child(item2)


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
	
