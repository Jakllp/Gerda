extends Path2D

class_name ParabolicProjectile

@export var speed: int = 15
@onready var follow: PathFollow2D = $PathFollow2D

var peak_ratio: float
var parabel_fac: float


func _physics_process(delta) -> void:
	follow.progress_ratio += x_of_p()
	if follow.progress_ratio == 1:
		release()
	
	
func x_of_p() -> float:
	return pow((follow.progress_ratio - peak_ratio), 2) * 1/speed + 0.007


func release() -> void:
	queue_free()
