extends Control

@onready var badger_button = $VBoxContainer/HBoxContainer/BadgerButton

signal character_selected(character: Main.Character)
signal switch_scene(scene: Main.Scene)

func _ready():
	badger_button.disabled = true
	

func _on_back_pressed():
	switch_scene.emit(Main.Scene.START)


func _on_mole_button_pressed():
	character_selected.emit(Main.Character.MOLE)
	

func _on_badger_button_pressed():
	character_selected.emit(Main.Character.BADGER)
	
