extends StaticBody2D

class_name InteractableBase


var player :Player


signal start_interaction()
signal stop_interaction()

func _ready() -> void:
	set_process(false)


func _process(delta):
	if Input.is_action_pressed("interact"):
		start_interaction.emit()
	if Input.is_action_just_released("interact"):
		stop_interaction.emit()


# We only want to process this when the player is near the interactable
func _on_detection_area_body_entered(body :Node2D):
	if player == null and body is Player:
		player = body
	set_process(true)


func _on_detection_area_body_exited(body):
	set_process(false)
	stop_interaction.emit()
