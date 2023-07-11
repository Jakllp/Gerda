extends FlashComponent

class_name PlayerDamageIndicatorComponent

var standard_vignette_enabled := false
var standard_vignette_color := Color(1.0,0,0,1)
var standard_vignette_softness := 3.0

func flash(le_owner :Player, damage_type :HealthComponent.DamageType):
	super.flash(le_owner, damage_type)
	var vig_node = le_owner.get_node("Camera2D/CanvasLayer/VignetteEffekt")
	var vig_shader_mat = vig_node.material
	var tweeny :Tween = le_owner.create_tween()
	
	vig_node.material.set_shader_parameter("vignette_color", self.standard_vignette_color)
	vig_shader_mat.set_shader_parameter("softness", self.standard_vignette_softness)
	vig_node.visible = true
	tweeny.tween_method(set_vig_softness.bind(le_owner), self.standard_vignette_softness, 1.0, 0.03)
	
	# Screen-Shake when poisoned
	match(damage_type):
		HealthComponent.DamageType.POISON:
			le_owner.get_node("Camera2D").apply_noise_screen_shake(7.5, 5.0, 1.0, 20.0)
		_:
			le_owner.get_node("Camera2D").apply_noise_screen_shake(25, 5.0, 1.0, 30.0)
	


func reset_shader_values(le_owner):
	super.reset_shader_values(le_owner)
	if not is_instance_valid(le_owner): return
	var vig_node = le_owner.get_node("Camera2D/CanvasLayer/VignetteEffekt")
	var vig_shader_mat = vig_node.material
	var tweeny :Tween = le_owner.create_tween()
	
	if(standard_vignette_enabled):
		tweeny.tween_method(set_vig_softness.bind(le_owner), vig_shader_mat.get_shader_parameter("softness"), self.standard_vignette_softness, 0.15)
	else:
		tweeny.tween_method(set_vig_softness.bind(le_owner), vig_shader_mat.get_shader_parameter("softness"), self.standard_vignette_softness, 0.15)
		tweeny.tween_callback(disable_vig.bind(vig_node))


func disable_vig(vig_node) -> void:
	vig_node.visible = false
	vig_node.material.set_shader_parameter("vignette_color", self.standard_vignette_color)


func set_vig_softness(value :float, le_owner):
	le_owner.get_node("Camera2D/CanvasLayer/VignetteEffekt").material.set_shader_parameter("softness", value)
