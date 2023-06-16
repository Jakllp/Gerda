extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://resources/menus/CharacterSelectScreen.tscn")
	
	
func _on_options_menu_pressed():
	get_tree().change_scene_to_file("res://resources/menus/OptionsMenu.tscn")
	
	
func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://resources/menus/CreditsScreen.tscn")
	
	
func _on_quit_menu_pressed():
	get_tree().quit()
