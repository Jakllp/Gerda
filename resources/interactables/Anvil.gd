extends StaticBody2D

class_name Anvil

@export var loading_ring_scene :PackedScene
@export var crafting_time :float
@onready var crafting_tween :Tween

var player = null
var loading_ring :TextureProgressBar = null

func _ready() -> void:
	new_tween()


func new_tween() -> void:
	crafting_tween = self.create_tween()
	crafting_tween.stop()


func do_interaction() -> void:
	if player == null:
		player = $InteractableBase.player
	if !crafting_tween.is_running() and player.ore_pouch > 0 and player.weapon.needs_crafting():
		#crafting_tween.tween_method(set_shader_value, 0.0, 0.7, crafting_time)
		loading_ring = loading_ring_scene.instantiate()
		self.add_child(loading_ring)
		loading_ring.position.y -= 15
		crafting_tween.tween_method(do_loading_ring, 0.0, 1.0, crafting_time)
		crafting_tween.tween_callback(craft)
		crafting_tween.play()


func set_shader_value(value: float):
	$Sprite2D.material.set_shader_parameter("flash_modifier", value)


## Tells the loading_ring to do something
func do_loading_ring(value: float):
	if is_instance_valid(loading_ring):
		loading_ring.value = 100.0*value
	

func stop_interaction() -> void:
	set_shader_value(0.0)
	crafting_tween.stop()
	if is_instance_valid(loading_ring):
		loading_ring.queue_free()


func craft() -> void:
	player.weapon.crafted()
	player.ore_pouch -= 1
	set_shader_value(0.0)
	do_loading_ring(0.0)
	new_tween()
