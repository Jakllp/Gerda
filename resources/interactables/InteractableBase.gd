extends StaticBody2D

class_name InteractableBase


func _ready() -> void:
	set_process(false)


func _process(delta):
	if Input.is_action_pressed("interact"):
		do_interaction()


# Do the interactables function
func do_interaction() -> void:
	pass


# We only want to process this when the player is near the interactable
func _on_detection_area_body_entered(body):
	set_process(true)


func _on_detection_area_body_exited(body):
	set_process(false)
