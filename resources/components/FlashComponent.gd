extends RefCounted

class_name FlashComponent

# Avoid staying white after flash if two flashes are triggered to close to each other
var flashing := false
var standard_flash_color := Color(1,1,1,1)
var standard_modifier := 0.0

## Handles the visual flashing
func flash(le_owner, _damage_type :HealthComponent.DamageType):
	while flashing:
		if is_instance_valid(le_owner):
			await le_owner.get_tree().create_timer(0.01).timeout
		else:
			return
	if not is_instance_valid(le_owner): return
	
	flashing = true
	var shader_mat = le_owner.get_node("SubViewportContainer/SubViewport/AnimatedSprite2D").material
	
	shader_mat.set_shader_parameter("flash_color", Color(1,1,1,1))
	shader_mat.set_shader_parameter("flash_modifier",0.4)
	prints(le_owner, "flashed")
	await le_owner.get_tree().create_timer(0.05).timeout
	
	flashing = false
	reset_shader_values(le_owner)


## Resets the flash to whatever it was before -> e.g. you can flash whilst staying visually poisoned
func reset_shader_values(le_owner):
	while flashing:
		if is_instance_valid(le_owner):
			await le_owner.get_tree().create_timer(0.01).timeout
		else:
			return
	if not is_instance_valid(le_owner): return
	
	var shader_mat = le_owner.get_node("SubViewportContainer/SubViewport/AnimatedSprite2D").material
	shader_mat.set_shader_parameter("flash_modifier",standard_modifier)
	shader_mat.set_shader_parameter("flash_color", standard_flash_color)
