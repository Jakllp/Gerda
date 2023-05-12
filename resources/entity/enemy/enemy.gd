extends Entity

class_name Enemy

@onready var input_component = EnemyInputComponent.new()
var nav_map: RID

var player: Player
var active: bool = false

#only for debugging and testing purposes to see the navigation path
var path :PackedVector2Array


func _ready() -> void:
	var tree := get_tree()
	if tree.has_group("player"):
		player = tree.get_first_node_in_group("player")
	if tree.has_group("map"):
		nav_map = tree.get_first_node_in_group("map").get_navigation_map(0)


func _physics_process(delta: float) -> void:
	input_component.update(self)
	super._physics_process(delta)


func _on_acitvation_range_body_entered(body):
	if body is Player:
		active = true
