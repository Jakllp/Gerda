extends BoxContainer

var max_hp

func _on_supervised_health_component_hp_changed(previous, diff):
	$TextureProgressBar.value = 100*(float(previous+diff) / float(max_hp))


func _on_supervised_health_component_max_hp_changed(value):
	max_hp = value
