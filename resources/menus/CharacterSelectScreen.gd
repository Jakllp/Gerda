extends Control

func _on_mole_pressed():
	get_tree().change_scene_to_file("res://resources/menus/MutatorSelectScreen.tscn")


func _on_badger_pressed():
	get_tree().change_scene_to_file("res://resources/menus/MutatorSelectScreen.tscn")


func _on_back_pressed():
	get_tree().change_scene_to_file("res://resources/menus/StartMenu.tscn")
