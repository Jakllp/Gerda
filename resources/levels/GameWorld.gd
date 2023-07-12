extends Node2D
class_name GameWorld

enum Level {
	START,
	BIOM,
	BOSS,
	END
}

enum Biome {
	FILLER, # Filler value to have value 1 for biome 1 
	BIOME_1
}

#enum State {
#	MUTATOR_SELECT,
#	PAUSE,
#	GAME,
#	LOADING
#}

const mutator_effects = {
	"time" : [0.95, 0.85, 0.72, 0.7, 0.65, 0.6],
	"time_deviation" : [1, 1.1, 1.3, 0.8, 0.75, 0.6],
	"size" : [1, 1, 1, 1, 1, 1],
	"size_deviation" : [1, 1, 1, 1, 1, 1],
	"max_weight" : [1, 1, 1, 1, 1, 1]
}

var level_scene := preload("res://resources/levels/Level.tscn")
var boss_scene_path := {
	Biome.BIOME_1 : "res://resources/levels/bossroom/SpiderRoom.tscn"
}

const min_loading_time := 4

var current_level = Level.START
var current_biome = Biome.BIOME_1

var spawn_time: float = 30
var spawn_time_deviation: float = 4
var spawn_size = 3
var spawn_size_deviation = 1
# TODO: implement this
var max_enemy_weight = 60
var thready :Thread

@onready var spawn_timer := $SpawnTimer
@onready var loading_timer := $LoadingTimer
@onready var interface := $CanvasLayer/Interface
@onready var mutator_select_screen := $CanvasLayer/MutatorSelectScreen
@onready var loading_screen := $CanvasLayer/LoadingScreen
@onready var pause_menu := $CanvasLayer/PauseMenu
@onready var player := $Player

signal switch_scene(scene: Main.Scene)

func _ready() -> void:
	player.died.connect(on_player_died)
	pause_menu.game_abandoned.connect(on_game_abandoned)
	mutator_select_screen.mutator_selected.connect(on_mutator_selected)
	
	proceed_level()
	

func proceed_level() -> void:
	current_level += 1
	if current_level == Level.END:
		switch_scene.emit(Main.Scene.VICTORY)
		return
	var level = get_node_or_null("Level")
	if level != null:
		level.queue_free()
	if current_level == Level.BOSS:
		var boss_room = load(boss_scene_path[current_biome]).instantiate()
		player.global_position = boss_room.get_node("PlayerSpawnPoint").global_position
		add_child(boss_room)
		spawn_timer.paused = true
		current_biome += 1
		if current_biome < Biome.size():
			current_level -= 2
	else:
		change_to_mutator_select()
	

func change_to_mutator_select() -> void:
	player.process_mode = Node.PROCESS_MODE_DISABLED
	visible = false
	interface.visible = false
	loading_screen.visible = false
	mutator_select_screen.visible = true
	pause_menu.pausable = false
	

func on_mutator_selected(mutator) -> void:
	update_mutators()
	interface.add_mutator(mutator)
	# show loading screen until world is generated
	mutator_select_screen.visible = false
	loading_screen.visible = true
	
	thready = Thread.new()
	thready.start(create_level)
	# The min amount the loading screen should be there
	loading_timer.start(min_loading_time)


func create_level() -> Node:
	var level: Level = level_scene.instantiate()
	level.generate(current_biome)
	call_deferred("on_level_generated")
	return level

func on_level_generated() -> void:
	# Wait for min-amount timer to be stopped if it is still running
	if not loading_timer.is_stopped():
		await loading_timer.timeout
	
	add_child(thready.wait_to_finish())
	player.process_mode = Node.PROCESS_MODE_INHERIT
	
	# Avoid "jitter"
	await get_tree().create_timer(0.5).timeout
	
	visible = true
	interface.visible = true
	loading_screen.visible = false
	pause_menu.pausable = true
	spawn_timer.paused = false
	start_spawn_timer()


func on_game_abandoned() -> void:
	switch_scene.emit(Main.Scene.START)
	

func on_player_died() -> void:
	switch_scene.emit(Main.Scene.GAME_OVER)
	

func start_spawn_timer() -> void:
	var time = randfn(spawn_time, spawn_time_deviation)
	prints("start spawn timer for", time, "seconds")
	spawn_timer.start(time)
	

func get_spawn_size() -> int:
	return round(randfn(spawn_size, spawn_size_deviation))
	

func update_mutators() -> void:
	var level = MutatorManager.get_modifier_for_type(Mutator.MutatorType.SPAWN_PLUS, true) - 1
	if level < 0:
		return
	spawn_time *= mutator_effects["time"][level]
	spawn_time_deviation *= mutator_effects["time_deviation"][level]
	spawn_size *= mutator_effects["size"][level]
	spawn_size_deviation *= mutator_effects["size_deviation"][level]
	max_enemy_weight *= mutator_effects["max_weight"][level]
	

func _on_spawn_timer_timeout():
	var size = get_spawn_size()
	if not EnemyCreator.spawn_random_grouped_wave(current_level, size):
		EnemyCreator.spawn_random_wave(current_level, size)
	start_spawn_timer()
	

static func check_line_of_sight(who: Node2D, from: Vector2, to: Vector2, collision_mask: int, exclude: Array[RID]=[]) -> bool:
	# prepare and execute raycast
	var space_state :PhysicsDirectSpaceState2D = who.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = exclude
	query.collision_mask = collision_mask
	var result := space_state.intersect_ray(query)
	# if nothing was in the way there is a line of sight
	if result.is_empty():
		return true
	else:
		return false
