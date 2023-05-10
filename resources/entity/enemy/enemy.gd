extends Entity

class_name Enemy

@onready var inputComponent = EnemyInputComponent.new()
@onready var navi = $NavigationAgent2D

var query_parameters = NavigationPathQueryParameters2D.new()
var query_result  = NavigationPathQueryResult2D.new()


var player: Player

func _ready() -> void:
	navi.debug_enabled = true
	
	var tree := get_tree()
	if tree.has_group("player"):
		player = tree.get_first_node_in_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#inputComponent.update(self)
	var pp = player.global_position

	navi.target_position = pp
	var target = navi.get_next_path_position()

	direction = position.direction_to(target)

	if Input.is_action_just_pressed("LMB"):
		print("pp: ",pp)
		print("tapos: ",navi.target_position)
		print("pos: ",position)
		print("ta: ", target)
		print("dir: ", rad_to_deg(direction.angle()))#
		print()
	super._physics_process(delta)
