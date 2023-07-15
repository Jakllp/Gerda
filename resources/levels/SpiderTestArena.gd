extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var from = $From.global_position
	var to = $To.global_position
	printt("from", from, "to", to)
	print(get_world_2d().navigation_map == $Spider.get_world_2d().navigation_map)
	var map_point = NavigationServer2D.map_get_closest_point(get_world_2d().navigation_map, to)
	var path = NavigationServer2D.map_get_path(get_world_2d().navigation_map, from, to, true)
	prints("map_point", map_point)
	prints("path", path)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var paused = false
func _unhandled_input(event):
	if event is InputEventKey and event.is_action_pressed("ui_cancel"):
		if paused:
			paused = false
			$Spider.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			paused = true
			$Spider.process_mode = Node.PROCESS_MODE_INHERIT
