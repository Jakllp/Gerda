extends Control

@onready var badger_button = $VBoxContainer/HBoxContainer/BadgerButton

func _ready():
	badger_button.disabled = true
	

func _on_back_pressed():
	get_tree().change_scene_to_file("res://resources/menus/StartMenu.tscn")


func _on_mole_button_pressed():
	get_tree().change_scene_to_file("res://resources/menus/MutatorSelectScreen.tscn")


func _on_badger_button_pressed():
	get_tree().change_scene_to_file("res://resources/menus/MutatorSelectScreen.tscn")
