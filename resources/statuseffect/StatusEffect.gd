extends RefCounted
class_name StatusEffect

var onwer
var trigger_time: float = 0
var passed_time: float = 0
var life_time: float = 0
var passed_life_time: float = 0

var one_time_trigger = false
var trigger_enabled = true

func _init(trigger_time: float = -1, life_time: float = -1):
	self.trigger_time = trigger_time
	self.life_time = life_time
	if trigger_time < 0:
		one_time_trigger = true

func process(delta: float, owner) -> void:
	passed_time += delta
	passed_life_time += delta
	if trigger_enabled and passed_time >= trigger_time:
		if one_time_trigger:
			trigger_enabled = false
		passed_time = delta
		trigger(owner)
	

func refresh() -> void:
	passed_life_time = 0

func trigger(owner) -> void:
	pass 
	
	
