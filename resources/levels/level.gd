extends Node2D

@onready var line := $Line2D

func _ready() -> void:
	line.width = 3


func _physics_process(delta: float) -> void:
	if get_tree().has_group("enemy"):
		line.points = get_tree().get_first_node_in_group("enemy").path
	else:
		line.clear_points()
