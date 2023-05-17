extends Entity

class_name Enemy

#only for debugging and testing purposes to see the navigation path
var path :PackedVector2Array
## For melee attacks the time it takes to execute the actual attack
## For ranged attacks the velocity of the projectile
@export var attack_speed: float
##the time between succesive attacks
@export var attack_cooldown: float

func _ready() -> void:
	super._ready()
	set_physics_process(false)
	$BTRoot.enabled = false
	$BTBlackboard.set_data("nav_map", get_tree().get_first_node_in_group("map").get_navigation_map(0))


func _physics_process(delta: float) -> void:
	super._physics_process(delta)


func attack() -> void:
	pass


func _on_activation_range_body_entered(body: Node2D) -> void:
	if body is Player:
		if not is_physics_processing():
			set_physics_process(true)
			$BTRoot.enabled = true


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body is Player:
		attack()
