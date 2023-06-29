extends Node2D

const max_enemies = 50
const enemy_spawn_area_size = 20
const enemy_spawn_area_spacing = 10
const min_spawn_distance = 150
const max_spawn_distance = 260
const pos_query_collision_mask = 36
const spawn_tries = 15

const spawn_point_tex := preload("res://asset/visual/icon.svg")
const spider_scene := preload("res://resources/entity/enemy/spider/Spider.tscn")
const worm_scene := preload("res://resources/entity/enemy/worm/Worm.tscn")

const spawn_prob_table := {
	GameWorld.Level.BIOM_1 : {spider_scene : 3, worm_scene : 1}
}
const enemy_weight_table := {
	GameWorld.Level.BIOM_1 : {spider_scene : 3, worm_scene: 4}
}

var prob_sum := {}


func _ready() -> void:
	for biom in spawn_prob_table:
		prob_sum[biom] = 0
		for value in spawn_prob_table[biom].values():
			assert(value is int and value > 0, str(value)+" is invalid weight for enemy probability")
			prob_sum[biom] += value
	

func spawn_random_enemy(biom: GameWorld.Level) -> bool:
	var pos = get_random_spawn_pos()
	if pos == Vector2.INF:
		return false
	else:
		spawn_enemy(get_random_enemy(biom), pos)
		return true
	

## Spawn enemy with spawn animation
func spawn_enemy(enemy: PhysicsBody2D, pos: Vector2) -> void:
	var enemy_container = get_tree().get_first_node_in_group("enemies")
	if not is_instance_valid(enemy_container):
		return
	var spawn_point := Sprite2D.new()
	spawn_point.texture = spawn_point_tex
	spawn_point.scale = Vector2(0.1, 0.1)
	spawn_point.global_position = pos
	spawn_point.z_index = 1
	spawn_point.modulate = Color(0,0,0,0)
	enemy_container.add_child(spawn_point)
	
	var tween = create_tween()
	tween.tween_property(spawn_point, "modulate", Color(0,0,0,1), 5)
	tween.tween_callback(spawn_point.queue_free)
	
	await tween.finished
	if not is_instance_valid(enemy_container):
		return
	enemy.global_position = pos
	enemy_container.add_child(enemy)
	

## Spawn enemy without animation
func spawn_enemy_raw(enemy:PhysicsBody2D, pos: Vector2) -> void:
	enemy.global_position = pos
	var enemy_container = get_tree().get_first_node_in_group("enemies")
	if not is_instance_valid(enemy_container):
		return
	enemy_container.add_child(enemy)
	

func spawn_random_wave(biom: GameWorld.Level, size: int) -> void:
	for i in size:
		spawn_random_enemy(biom)
	

func spawn_wave(enemies: Array, coordinates: Array) -> void:
	assert(enemies.size() == coordinates.size(), "number of enemies doesn't match with the number of coordinates"+str(enemies.size())+" : "+str(coordinates.size()))
	for i in enemies.size():
		assert(coordinates[i] is Vector2, "given coordinate is not Vector2. Is: "+str(coordinates[i]))
		spawn_enemy(enemies[i], coordinates[i])
		

func spawn_enemy_in_area(enemy, area: Rect2, index: int) -> void:
	var row_count = area.size.y / enemy_spawn_area_size
	var col_count = area.size.x / enemy_spawn_area_size
	var row = floor(index / row_count)
	var col = index - row * row_count
	var shift = Vector2(col + 0.5, row + 0.5) * Vector2(randi_range(enemy_spawn_area_size, enemy_spawn_area_size+enemy_spawn_area_spacing),randi_range(enemy_spawn_area_size, enemy_spawn_area_size+enemy_spawn_area_spacing))
	spawn_enemy(enemy, area.position + shift)

func spawn_grouped_wave(enemies: Array, area: Rect2) -> void:
	for i in enemies.size():
		spawn_enemy_in_area(enemies[i], area, i)
		

func spawn_random_grouped_wave(biom: GameWorld.Level, size: int) -> bool:
	var area = get_randpm_spawn_area(size)
	if area.size == Vector2.ZERO:
		return false
	for i in size:
		spawn_enemy_in_area(get_random_enemy(biom), area, i)
	
	return true

func get_random_enemy(biom: GameWorld.Level):
	var enemy
	var rand_val = randi_range(0, prob_sum[biom] - 1)
	for key in spawn_prob_table[biom]:
		rand_val -= spawn_prob_table[biom][key]
		if rand_val < 0:
			enemy = key
			break
	assert(enemy != null, "something went wrong when choosing a random enemy")
	return enemy.instantiate()
	

func get_random_spawn_pos() -> Vector2:
	print("try to get random spawn pos")
	var player_pos = get_tree().get_first_node_in_group("player").global_position
	var pos: Vector2
	var found_smth = false
	var range: int
	var rot: float
	var result: Array
	var space_state := get_world_2d().direct_space_state
	for try in spawn_tries:
		range = randi_range(min_spawn_distance,max_spawn_distance)
		rot = randf_range(-PI, PI)
		pos = player_pos + (Vector2.RIGHT * range).rotated(rot)
		prints("range", range, "rot", rot, "ppos", player_pos, "pos", pos)
		
		var query := PhysicsPointQueryParameters2D.new()
		query.position = pos
		query.collision_mask = pos_query_collision_mask
		
		result = space_state.intersect_point(query)
		printt("result:", result)
		if result.is_empty():
			found_smth = true
			break
	
	if found_smth:
		printt("found pos:", pos)
		return pos
	else:
		print("couldn't find anything")
		return Vector2.INF
	

func get_randpm_spawn_area(enemy_count: int) -> Rect2:
	print("try to get random spawn area")
	var player_pos = get_tree().get_first_node_in_group("player").global_position
	var pos: Vector2
	var found_smth = false
	var range: int
	var rot: float
	var result: Array
	var space_state := get_world_2d().direct_space_state
	var shape_rid = PhysicsServer2D.rectangle_shape_create()
	# make horizontal rectangle size
	var size := Vector2(ceil(sqrt(enemy_count)), floor(sqrt(enemy_count))) * (enemy_spawn_area_size + enemy_spawn_area_spacing)
	PhysicsServer2D.shape_set_data(shape_rid, size)
	
	for try in spawn_tries:
		range = randi_range(min_spawn_distance,max_spawn_distance)
		rot = randf_range(-PI, PI)
		pos = player_pos + (Vector2.RIGHT * range).rotated(rot)
		prints("range", range, "rot", rot, "ppos", player_pos, "try_pos", pos)
		
		var query := PhysicsShapeQueryParameters2D.new()
		query.shape_rid = shape_rid
		query.collision_mask = pos_query_collision_mask
		query.transform = Transform2D(0, pos)
		
		result = space_state.intersect_shape(query)
		printt("results:", result.size())
		if result.is_empty():
			found_smth = true
			break
	
	PhysicsServer2D.free_rid(shape_rid)
	
	if found_smth:
		var area := Rect2(pos, size)
		printt("found area:", area)
		return area
	else:
		print("couldn't find a fitting spot for the spawning area")
		return Rect2()
