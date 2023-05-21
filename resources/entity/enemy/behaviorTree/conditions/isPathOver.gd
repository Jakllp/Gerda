extends BTCondition

@export var move_path_key: String
@export var path_index_key: String

func tick(actor:Node, blackboard:BTBlackboard):
	if blackboard.get_data(path_index_key) >= blackboard.get_data(move_path_key).size() - 1:
		return BTTickResult.SUCCESS
	else:
		return BTTickResult.FAILURE

