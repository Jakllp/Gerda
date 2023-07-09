extends Node2D

const max_enemies = 50
const enemy_spawn_area_size = 20
const enemy_spawn_area_spacing = 7
const min_spawn_distance = 150
const max_spawn_distance = 260
const pos_query_collision_mask = 36
const spawn_tries = 15

const spawn_point_tex := preload("res://asset/visual/icon.svg")
const spider_scene := preload("res://resources/entity/enemy/spider/Spider.tscn")
const worm_scene := preload("res://resources/entity/enemy/worm/Worm.tscn")

const spawn_prob_table := {
	GameWorld.Biome.BIOME_1 : {spider_scene : 3, worm_scene : 1}
}
const enemy_weight_table := {
	GameWorld.Biome.BIOME_1 : {spider_scene : 3, worm_scene: 4}
}

var prob_sum := {}
var shape := RectangleShape2D.new()


func _ready() -> void:
	for biom in spawn_prob_table:
		prob_sum[biom] = 0
		for value in spawn_prob_table[biom].values():
			assert(value is int and value > 0, str(value)+" is invalid weight for enemy probability")
			prob_sum[biom] += value
	

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
	

func spawn_wave(enemies: Array, coordinates: Array) -> void:
	assert(enemies.size() == coordinates.size(), "number of enemies doesn't match with the number of coordinates"+str(enemies.size())+" : "+str(coordinates.size()))
	for i in enemies.size():
		assert(coordinates[i] is Vector2, "given coordinate is not Vector2. Is: "+str(coordinates[i]))
		spawn_enemy(enemies[i], coordinates[i])
		

func spawn_enemy_in_area(enemy, area: Rect2, index: int) -> void:
	var row_count = area.size.y / (enemy_spawn_area_size + enemy_spawn_area_spacing)
	var row = floor(index / row_count)
	var col = index - row * row_count
	var shift = Vector2(col + 0.5, row + 0.5) * Vector2(randi_range(enemy_spawn_area_size, enemy_spawn_area_size+enemy_spawn_area_spacing),randi_range(enemy_spawn_area_size, enemy_spawn_area_size+enemy_spawn_area_spacing))
	spawn_enemy(enemy, area.position + shift)
	

func spawn_grouped_wave(enemies: Array, area: Rect2) -> void:
	for i in enemies.size():
		spawn_enemy_in_area(enemies[i], area, i)
		

func spawn_random_enemy(biom: GameWorld.Level) -> bool:
	var area = get_random_spawn_area(1)
	if area.size == Vector2.ZERO:
		return false
	else:
		spawn_enemy_in_area(get_random_enemy(biom), area, 0)
		return true
	

func spawn_random_wave(biom: GameWorld.Level, size: int) -> void:
	for i in size:
		spawn_random_enemy(biom)
	

func spawn_random_grouped_wave(biom: GameWorld.Level, size: int) -> bool:
	var area = get_random_spawn_area(size)
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
	

func get_random_spawn_area(enemy_count: int) -> Rect2:
	print("\ntry to get random spawn area")
	var player_pos = get_tree().get_first_node_in_group("player").global_position
	var pos: Vector2
	var spawn_range: int
	var rot: float
	var result
	var space_state := get_world_2d().direct_space_state
	# make horizontal rectangle size
	var width = ceil(sqrt(enemy_count))
	var height = ceil(enemy_count/width)
	var size := Vector2(width, height) * (enemy_spawn_area_size + enemy_spawn_area_spacing)
	shape.size = size
	print("shape size: ", size)
	
	for try in spawn_tries:
		spawn_range = randi_range(min_spawn_distance,max_spawn_distance)
		rot = randf_range(-PI, PI)
		# here is the position the middle of the rectangle
		pos = player_pos + (Vector2.RIGHT * spawn_range).rotated(rot)
		
		var query := PhysicsShapeQueryParameters2D.new()
		query.shape = shape
		query.collision_mask = pos_query_collision_mask
		query.transform = Transform2D(0, pos)
		
		result = space_state.intersect_shape(query)
		if result.is_empty():
			print("tries: ", try+1)
			print("results: ", result)
			# here the position is the upper left corner of the rectangle
			var area := Rect2(pos - size/2, size)
			
			printt("found area:", area)
			return area
	
	print("couldn't find a fitting spot for the spawning area")
	return Rect2()
