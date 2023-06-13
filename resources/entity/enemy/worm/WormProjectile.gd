extends ParabolicProjectile

var puddle_scene: PackedScene = preload("res://resources/entity/enemy/worm/PoisonPuddle.tscn")


func _ready():
	super._ready()


func _physics_process(delta):
	super._physics_process(delta)
	

func release() -> void:
	var puddle = puddle_scene.instantiate()
	puddle.transform = follow.global_transform
	get_node("/root").add_child(puddle)
	super.release()
