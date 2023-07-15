extends Control

signal switch_scene(scene: Main.Scene)

func _on_button_pressed():
	switch_scene.emit(Main.Scene.START)
