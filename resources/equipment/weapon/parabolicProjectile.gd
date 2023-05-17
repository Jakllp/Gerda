extends Path2D

class_name ParabolicProjectile

var peak_ratio: float = 0
var distance: float = 0

func _ready():
	
	pass
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
#	var x_ratio = Vector2(1,0).dot(target.normalized())
#	var angle: float = PI/2 - PI/4 * x_ratio
#	var flight_time: float = (speed * sin(angle) + sqrt(pow(speed,2) * pow(sin(angle),2) + 2 * gravity * target.y))
#	var ascend_time: float = (speed * sin(angle)) / gravity
#	var descend_time = flight_time - ascend_time
#	var height: float = (pow(speed,2) * pow(sin(angle),2)) / (2 * gravity)
#	var max_point: Vector2 = Vector2(cos(angle)*speed*ascend_time, height)
#	var tween: Tween = self.create_tween()
#	tween.tween_property(self, "position", max_point, ascend_time)
#	tween.tween_property(self, "position", target, descend_time)
#
#	set_physics_process(false)
#
#	return
	
	var d_prog = (distance/5000) * pow($PathFollow2D.progress_ratio - peak_ratio, 2)

	if d_prog <= delta:
		d_prog += delta

	$PathFollow2D.progress_ratio += d_prog
	if Input.is_action_just_pressed("RMB"):
#		print("progress: ", $PathFollow2D.progress_ratio)
#		print("glob: ", $PathFollow2D.global_position)
#		print("pos: ", $PathFollow2D.position, "\n")
#
#		print("distance/100: ", distance/100)
#		print(peak_ratio)
#		print("a: ", pow($PathFollow2D.progress_ratio - peak_ratio, 2))
		print("d_prog: ", d_prog)
		
		print()
