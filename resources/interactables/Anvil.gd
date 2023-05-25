extends InteractableBase

class_name Anvil

@export var crafting_time :float
@onready var crafting_tween :Tween


func _ready():
	new_tween()


func new_tween() -> void:
	crafting_tween = self.create_tween()
	crafting_tween.stop()


func do_interaction() -> void:
	if player == null:
		player = $InteractableBase.player
	if !crafting_tween.is_running() and player.ore_pouch > 0 and player.weapon.needs_crafting():
		print(player.ore_pouch)
		crafting_tween.tween_method(set_shader_value, 0.0, 0.7, crafting_time)
		crafting_tween.tween_callback(craft)
		crafting_tween.play()


func set_shader_value(value: float):
	$Sprite2D.material.set_shader_parameter("flash_modifier", value)


func stop_interaction() -> void:
	set_shader_value(0.0)
	crafting_tween.stop()


func craft() -> void:
	print("Crafting!")
	player.weapon.crafted()
	player.ore_pouch -= 1
	set_shader_value(0.0)
	new_tween()
