extends StaticBody2D



func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func shoot_web() -> void:
	var player_pos = get_tree().get_first_node_in_group("player").global_position
	$ParabolicShooter.shoot(player_pos)
	

func _on_timer_timeout():
	shoot_web()
