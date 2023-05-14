extends BTAction

@export var path_index_key: String
@export var move_path_key: String
@export var point_reached_margin: int

func tick(actor:Node, blackboard:BTBlackboard):
	var path:PackedVector2Array = blackboard.get_data(move_path_key)
	var index:int = blackboard.get_data(path_index_key, 0)
	if actor.global_position.distance_to(path[index]) < point_reached_margin:
		if index + 1 >= path.size():
			actor.direction = Vector2.ZERO
			return BTTickResult.SUCCESS
		index += 1
		blackboard.set_data(path_index_key, index)
		
	actor.direction = actor.global_position.direction_to(path[index])
	#print("position: ", actor.global_position, " _____ target: ", path[index], " _____ index: ", index, "  _____ direction: ", actor.direction)
	return BTTickResult.RUNNING

