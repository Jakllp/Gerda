extends ColorRect

var pausable = false

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var play_button: Button = $Buttons/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var quit_button: Button = $Buttons/PanelContainer/MarginContainer/VBoxContainer/QuitButton
@onready var accept_dialog = $AcceptDialog

signal game_abandoned

func _ready() -> void:
	visible = false
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
	

func _unhandled_input(event):
	if event is InputEventKey and event.is_action_pressed("ui_cancel"):
		if pausable:
			if visible == true:
				unpause()
			else:
				pause()
			get_viewport().set_input_as_handled()

func _on_quit_button_pressed():
	accept_dialog.visible = true
	accept_dialog.position = $Buttons/Marker2D.global_position - Vector2(accept_dialog.size / 2)


func _on_accept_dialog_canceled():
	accept_dialog.visible = false


func _on_accept_dialog_confirmed():
	get_tree().paused = false
	game_abandoned.emit()
	
