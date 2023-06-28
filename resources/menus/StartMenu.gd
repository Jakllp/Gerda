extends Control

@onready var start_button = $VBoxContainer/StartButton
@onready var options_button = $VBoxContainer/OptionsMenu
@onready var credits_button = $VBoxContainer/CreditsButton
@onready var quit_button = $VBoxContainer/QuitMenu

signal switch_scene(scene: Main.Scene)

func _ready():
	#Disable Buttons for Demo-Version
	#options_button.disabled = true
	#quit_button.disabled = true
	pass


func _on_start_button_pressed():
	switch_scene.emit(Main.Scene.CHARACTER_SELECT)
	
	
func _on_options_menu_pressed():
	switch_scene.emit(Main.Scene.OPTION)
	
	
func _on_credits_button_pressed():
	switch_scene.emit(Main.Scene.CREDIT)
	
	
func _on_quit_menu_pressed():
	get_tree().quit()
