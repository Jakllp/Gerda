extends ColorRect

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var play_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var options_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/OptionsButton
@onready var quit_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton
@onready var accept_dialog = $AcceptDialog

func _ready() -> void:
	visible = false
	get_tree().get_first_node_in_group("player").input_component.pause.connect(pause)
	play_button.pressed.connect(unpause)
	accept_dialog.add_cancel_button("Cancel")


func unpause():
	visible = false
	animator.play("Unpause")
	get_tree().paused = false


func pause():
	visible = true
	animator.play("Pause")
	get_tree().paused = true


func _on_quit_button_pressed():
	accept_dialog.visible = true


func _on_accept_dialog_canceled():
	accept_dialog.visible = false


func _on_accept_dialog_confirmed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://resources/menus/StartMenu.tscn")
