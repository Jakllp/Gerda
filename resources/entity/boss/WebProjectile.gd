extends ParabolicProjectile

var puddle_scene: PackedScene = preload("res://resources/entity/boss/Cobweb.tscn")


func _ready():
	super._ready()
	$PathFollow2D/AnimatedSprite2D.play("default")


func _physics_process(delta):
	super._physics_process(delta)
	

func release() -> void:
	var puddle = puddle_scene.instantiate()
	puddle.position = follow.global_position
	puddle.z_index = -1
	get_node("/root").add_child(puddle)
	super.release()
