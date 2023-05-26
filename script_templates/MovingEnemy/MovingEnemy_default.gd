# meta-description: Class template for moving enemies

extends _BASE_


func _ready() -> void:
	super._ready()


func _physics_process(delta: float) -> void:
	super._physics_process(delta)


func attack() -> void:
	pass


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body is Player:
		attack()
