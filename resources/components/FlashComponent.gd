extends Node

class_name FlashComponent


func flash(le_owner):
	var shader_mat = le_owner.get_node("SubViewportContainer/SubViewport/AnimatedSprite2D").material
	var color_before = shader_mat.get_shader_parameter("flash_color")
	var modifier_before = shader_mat.get_shader_parameter("flash_modifier")
	
	shader_mat.set_shader_parameter("flash_color", Color(1,1,1,1))
	shader_mat.set_shader_parameter("flash_modifier",0.4)
	await le_owner.get_tree().create_timer(0.05).timeout
	
	shader_mat.set_shader_parameter("flash_modifier",modifier_before)
	shader_mat.set_shader_parameter("flash_color", color_before)
