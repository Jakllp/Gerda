extends Node2D


var world_mutators = []
var enemy_mutators = []
var speed_mutators = []

## Returns an array with unique random mutator and strength-combos of the wanted size
func get_random_mutators(amount :int) -> Array:
	var types_with_strength = {}
	while types_with_strength.size() < amount:
		var type = randi_range(0, Mutator.MutatorType.size()-1)
		var strength = randi_range(0,2)
		if (types_with_strength.has(type) and types_with_strength[type] != strength) or not types_with_strength.has(type):
			# Not yet picked -> add it to dict
			types_with_strength[type] = strength
	
	var array = []
	for wanted_mutator in types_with_strength:
		array.append(Mutator.new(wanted_mutator, types_with_strength[wanted_mutator]))
	return array


## Adds a mutator to the current game
func add_mutator(mutator :Mutator) -> void:
	match(mutator.category):
		Mutator.MutatorCategory.WORLD_MUTATORS:
			world_mutators.append(mutator)
		Mutator.MutatorCategory.ENEMY_MUTATORS:
			enemy_mutators.append(mutator)
		Mutator.MutatorCategory.SPEED_MUTATORS:
			speed_mutators.append(mutator)
		_:
			pass


## Returns a value that can be used in a calculation.
## for_addition is false by default.
## With for_addition = false the function will return a value for multiplication (no mutator -> 1)
## With for_addition = true the function will return a value for addition (no mutator -> 0)
func get_modifier_for_type(type :Mutator.MutatorType, for_addition :bool = false):
	var all_in_the_category
	match(Mutator.category_for_type(type)):
		Mutator.MutatorCategory.WORLD_MUTATORS:
			all_in_the_category = world_mutators
		Mutator.MutatorCategory.ENEMY_MUTATORS:
			all_in_the_category = enemy_mutators
		Mutator.MutatorCategory.SPEED_MUTATORS:
			all_in_the_category = speed_mutators
		_:
			pass
	var combined_modifier = 0 if for_addition else 1
	for mutator in all_in_the_category:
		if mutator.type == type:
			if for_addition:
				combined_modifier += mutator.modifier
			else:
				combined_modifier *= mutator.modifier
	return combined_modifier


func get_active_mutators() -> Array:
	return world_mutators + enemy_mutators + speed_mutators
