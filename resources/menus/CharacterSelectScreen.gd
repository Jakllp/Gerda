extends Control

func _on_mole_pressed():
	get_tree().change_scene_to_file("res://resources/menus/mutator_select_screen.tscn")


func _on_badger_pressed():
	get_tree().change_scene_to_file("res://resources/menus/mutator_select_screen.tscn")


func _on_back_pressed():
	get_tree().change_scene_to_file("res://resources/menus/start_menu.tscn")
