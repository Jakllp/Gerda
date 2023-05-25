extends StaticBody2D

class_name InteractableBase


var player :Player


func _ready() -> void:
	set_process(false)


func _process(delta):
	if Input.is_action_pressed("interact"):
		do_interaction()
	if Input.is_action_just_released("interact"):
		stop_interaction()


# Do the interactables function
func do_interaction() -> void:
	pass


# Stop the Interaction
func stop_interaction() -> void:
	pass


# We only want to process this when the player is near the interactable
func _on_detection_area_body_entered(body :Node2D):
	if player == null:
		player = body
	owner.set_process(true)


func _on_detection_area_body_exited(body):
	owner.set_process(false)
	stop_interaction()
