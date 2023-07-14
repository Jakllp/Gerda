extends BTCondition

## Check if the actor is stuck by comparing the last few positions.

var previos_positions: Array[Vector2]
var count = 0
var stored_positions = 7
var is_stuck_margin = 1

func tick(actor:Node, _blackboard:BTBlackboard):
	var is_stuck = false
	if previos_positions.size() == stored_positions:
		var index = count % stored_positions
		previos_positions[index] = actor.global_position
		var check_pos: Vector2 = previos_positions[0]
		is_stuck = true
		for pos in previos_positions:
			is_stuck = (check_pos - pos).length_squared() < is_stuck_margin
			if not is_stuck:
				break
		count += 1
		if count < 0:
			count = 0
	else :
		previos_positions.append(actor.global_position)
	
	if is_stuck:
		previos_positions.clear()
		return BTTickResult.SUCCESS
	else:
		return BTTickResult.FAILURE
