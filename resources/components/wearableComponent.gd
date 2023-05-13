extends Marker2D

class_name WearableComponent

func update(player: Player) -> void:
	assert(owner != null, "Wearables owner shouldn't be null")
	
	check_for_flip(player)
	owner.do_rotation(player)


func check_for_flip(player: Player):
	var mousePos := player.get_local_mouse_position()
	# Check if flip is needed, if so -> Flip (also tell the player to flip)
	if mousePos.normalized().x < 0:
		if player.scale.x > 0:
			player.scale.x *= -1
	else:
		if player.scale.x < 0:
			player.scale.x *= -1


# Just point the item in hand towards the mouse
func aim_at_mouse_basic(player: Player):
	var mouse_pos := player.get_local_mouse_position()
	owner.rotation = mouse_pos.angle()
	owner.position = mouse_pos.normalized() * position.length() + player.equipment_angle_point


# If you want to point something towards the mouse that is held at a right angle
func aim_at_mouse_with_right_angled_grip(player: Player):
	var mouse_pos := player.get_local_mouse_position() - player.equipment_angle_point
	# Calculate some angles
	var mouse_distance := mouse_pos.length()
	# Don't know why the /3 is needed, but it is
	var rot_radius := position.length()
	
	# Just to spite Lea (angle between rotRadius and mouse)
	var hans := acos(rot_radius/mouse_distance)
	var mouse_angle = abs(mouse_pos.angle())
	
	var is_above_AP := mouse_pos.y < 0
	var is_above_center := (mouse_pos+position).y < 0
	var beta
	var sigma
	if is_above_AP:
		sigma = hans - mouse_angle
		beta = (PI/2) - hans + mouse_angle
	else:
		sigma = hans + mouse_angle 
		if is_above_center:
			beta = (PI/2) - hans - mouse_angle
		else:
			beta = (PI/2) - (PI-hans-mouse_angle)
	var gamma = (PI/2) - beta
	var alpha = (PI/2) - gamma
	
	# As long as the mouse is above the center of the gun we need to think full circle
	if is_above_center:
		alpha = 2*PI - alpha
	
	#  Actually rotate the equipment around it's origin
	owner.rotation = alpha
	
	# The position of the equipment adjusted for the rotation
	get_parent().position = player.equipment_angle_point + (Vector2.from_angle(sigma) * rot_radius)
