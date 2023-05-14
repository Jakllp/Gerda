extends BTAction

@export var wander_pos_key: String
@export var wander_target_radius: int = 200

func tick(actor:Node, blackboard:BTBlackboard):
	var dir = (actor.direction as Vector2).rotated(randf_range(-PI/2, PI/2))
	blackboard.set_data(wander_pos_key, dir * wander_target_radius)
	
	return BTTickResult.SUCCESS
