extends Control

signal switch_scene(scene: Main.Scene)

func _on_right_button_pressed():
	switch_scene.emit(Main.Scene.TUT3)


func _on_left_button_pressed():
	switch_scene.emit(Main.Scene.TUT1)


func _on_back_button_pressed():
	switch_scene.emit(Main.Scene.START)
