extends Control

signal switch_scene(scene: Main.Scene)

func _on_left_button_pressed():
	get_tree().change_scene_to_file("res://resources/menus/tutorialPages/TutorialPage3.tscn")


func _on_back_button_pressed():
	switch_scene.emit(Main.Scene.START)
