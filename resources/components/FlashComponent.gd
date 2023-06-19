extends Node

class_name FlashComponent


func flash(le_owner):
	var shader_mat = le_owner.get_node("SubViewportContainer/SubViewport/AnimatedSprite2D").material
	shader_mat.set_shader_parameter("flash_modifier",0.4)
	await le_owner.get_tree().create_timer(0.05).timeout
	shader_mat.set_shader_parameter("flash_modifier",0)
