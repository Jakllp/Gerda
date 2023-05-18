extends Marker2D

class_name ParabolicShooter

@export var projectile_scene: PackedScene
var number_of_points = 50.0
var target: Vector2
var velocity: float = 20
var gravity: float = 10.0

#at which point of the track is the maximum height reached
var peak_ratio

#angle from x axis to starting velocity vector
var alpha

func shoot(target: Vector2) -> void:
	print("target: ", target)
	self.target = target
	var p: ParabolicProjectile = projectile_scene.instantiate()
	p.curve = calculate_trajectory2()
	p.peak_ratio = peak_ratio
	add_child(p)
	
func calculate_trajectory2() -> Curve2D:
	var dot = Vector2.RIGHT.dot(target.normalized())
	alpha = PI/2 - PI/4 * dot	
	
	velocity = sqrt((gravity * pow(target.x,2)) / (2 * pow(cos(alpha),2) * (tan(alpha) * target.x + target.y)))

	var help = sqrt(velocity*velocity*sin(alpha) + 2*gravity*abs(target.y)) / (velocity * sin(alpha))
	peak_ratio = 1/(1+help)
	
	var curve = Curve2D.new()
	
	var x: float = 0
	var y: float = 0
	var point = Vector2(x, y)
	curve.add_point(point)
	for p in number_of_points:
		x = p/number_of_points * target.x
		y = y_of_x(x)
		point = Vector2(x,y)
		
		curve.add_point(point)
	
	return curve
	
func y_of_x(x:float) -> float:
	return -1.0 * x * (tan(alpha) - ((gravity * x) / (2 * pow(cos(alpha),2) * velocity*velocity)))
	
