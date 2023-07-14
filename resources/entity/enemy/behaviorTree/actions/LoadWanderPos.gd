extends BTAction

## Select a random position to wander around. 
## The direction of this position is normal distributed around 0 with a standard deviation of PI

## Key to store the wander position in the blackboard
@export var wander_pos_key: String


func tick(actor:Node, blackboard:BTBlackboard):
	var current_dir: Vector2 = actor.velocity.normalized() if actor.velocity != Vector2.ZERO else Vector2.RIGHT
	var next_dir = current_dir.rotated(randfn(0, PI))
	var wander_pos = actor.global_position + next_dir * randi_range(actor.min_wander_target_radius, actor.max_wander_target_radius)
	
	blackboard.set_data(wander_pos_key, wander_pos)
	return BTTickResult.SUCCESS
	
