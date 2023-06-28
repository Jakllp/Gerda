extends Control

@onready var start_button = $VBoxContainer/StartButton
@onready var options_button = $VBoxContainer/OptionsMenu
@onready var credits_button = $VBoxContainer/CreditsButton
@onready var quit_button = $VBoxContainer/QuitMenu

func _ready():
	#Disable Buttons for Demo-Version
	#options_button.disabled = true
	#quit_button.disabled = true
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://resources/menus/CharacterSelectScreen.tscn")
	
	
func _on_options_menu_pressed():
	get_tree().change_scene_to_file("res://resources/menus/OptionsMenu.tscn")
	
	
func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://resources/menus/CreditsScreen.tscn")
	
	
func _on_quit_menu_pressed():
	get_tree().quit()
