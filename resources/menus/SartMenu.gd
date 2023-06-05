extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://resources/menus/character_select_screen.tscn")
	
	
func _on_options_menu_pressed():
	get_tree().change_scene_to_file("res://resources/menus/options_menu.tscn")
	
	
func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://resources/menus/credits_screen.tscn")
	
	
func _on_quit_menu_pressed():
	get_tree().quit()
