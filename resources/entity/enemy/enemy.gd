extends Entity

class_name Enemy

@onready var input_component = EnemyInputComponent.new()
var nav_map: RID

var player: Player
var path :PackedVector2Array

func _ready() -> void:
	#navi.debug_enabled = true
	var map: TileMap
	
	var tree := get_tree()
	if tree.has_group("player"):
		player = tree.get_first_node_in_group("player")
	if tree.has_group("map"):
		map = tree.get_first_node_in_group("map")
	if map:
		nav_map = map.get_navigation_map(0)


func _physics_process(delta: float) -> void:
	path = NavigationServer2D.map_get_path(nav_map, global_position, player.global_position, false)
	
	if path.size() > 1:
		direction = global_position.direction_to(path[1])
		
		
	super._physics_process(delta)
