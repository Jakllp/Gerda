extends Node2D
class_name GameWorld

enum Biom {
	BIOM_1
}

const mutator_effects = {
	"time" : [0.95, 0.85, 0.72, 0.7, 0.65, 0.6],
	"time_deviation" : [1, 1.1, 1.3, 0.8, 0.75, 0.6],
	"size" : [1, 1, 1, 1, 1, 1],
	"size_deviation" : [1, 1, 1, 1, 1, 1],
	"max_weight" : [1, 1, 1, 1, 1, 1]
}
var current_biom = Biom.BIOM_1

var spawn_time: float = 30
var spawn_time_deviation: float = 4
var spawn_size = 4
var spawn_size_deviation = 2
var max_enemy_weight = 60

@onready var spawn_timer = $SpawnTimer

func _ready() -> void:
	update_mutators()
	start_timer()
	

func start_timer() -> void:
	var time = randfn(spawn_time, spawn_time_deviation)
	prints("start timer for", time, "seconds")
	spawn_timer.start(time)
	

func get_spawn_size() -> int:
	return randfn(spawn_size, spawn_size_deviation)
	

func update_mutators() -> void:
	var level = MutatorManager.get_modifier_for_type(Mutator.MutatorType.SPAWN_PLUS, true) - 1
	if level < 0:
		return
	spawn_time *= mutator_effects["time"][level]aaaa
	spawn_time_deviation *= mutator_effects["time_deviation"][level]
	spawn_size *= mutator_effects["size"][level]
	spawn_size_deviation *= mutator_effects["size_deviation"][level]
	max_enemy_weight *= mutator_effects["max_weight"][level]
	

func _on_spawn_timer_timeout():
	var size = get_spawn_size()
	if not EnemyCreator.spawn_random_grouped_wave(current_biom, spawn_size):
		EnemyCreator.spawn_random_wave(current_biom, spawn_size)
	start_timer()
