extends Marker2D

class_name ParabolicShooter

@export var projectile_scene: PackedScene
var number_of_points = 50.0
#speed
var v: float = 100
#gravity
var g: float = 10.0
#at which point of the track is the maximum height reached
var peak_ratio
# sinus of the alpha angle
var sa

func _ready():
	position = Vector2(600,300)

func _physics_process(delta) -> void:
	if Input.is_action_just_pressed("LMB"):
		shoot(get_local_mouse_position())

func shoot(target: Vector2) -> void:
	print("shoot: ", target)
	var projectile: ParabolicProjectile = projectile_scene.instantiate()
	print("pos: ", position)
	projectile.position = Vector2.ZERO
	var res = calculate_trajectory(target)
	projectile.curve = res[0]
	projectile.peak_ratio = res[1] / number_of_points
	projectile.distance = target.length()
	self.add_child(projectile)
	
	
func calculate_trajectory(target: Vector2) -> Array:
	var curve: Curve2D = Curve2D.new()
	
	var DOT = Vector2(1,0).dot(target.normalized())
	var angle = 90 - 45 * DOT
	print("angle: ", angle)
	
	var x_dist = target.x
	var y_dist = -1.0 * target.y
	
	var speed = sqrt(((0.5 * g * x_dist * x_dist) / pow(cos(deg_to_rad(angle)), 2.0)) / (y_dist - tan(deg_to_rad(angle)) * x_dist))
	var x_component = cos(deg_to_rad(angle)) * speed
	var y_component = sin(deg_to_rad(angle)) * speed
	print("speed: ", speed)
	print("x_comp: ", x_component)
	print("y_comp: ", y_component)
	
	var total_time = x_dist / x_component
	print("total_time: ", total_time)
	
	var line: Line2D = Line2D.new()
	
	var max_y = 0
	var max_point: float = 0.0
	for point in number_of_points:
		var time = total_time * (point / number_of_points)
		var dx = time * x_component
		var dy = -1.0 * (time * y_component + 0.5 * g * time * time)
#		print("point: ", point)
#		print("time: ", time)
#		print("dx: ", dx)
#		print("dy: ", dy)
#		print()
		if dy < max_y:
			print("new max: ", dy)
			max_point = point
		curve.add_point(Vector2(dx,dy))
		line.add_point(Vector2(dx,dy))
	
	add_child(line)
	return [curve, max_point]
	
func calculate_trajectory2(ta: Vector2) -> Curve2D:
	#angle from x axis to target
	var beta = acos(Vector2(1,0).dot(ta.normalized()) / (ta.length()))
	#angle from x axis to starting velocity vector
	var alpha = 90 - abs(beta)
	sa = sin(alpha)
	
	#maybe + instead of -
	var help = sqrt(v*v*sa - 2*g*ta.y) / (v * sa)
	#at which point of the track is the maximum height reached
	peak_ratio = 1/(1+help)
	
	var curve = Curve2D.new()
	
	var dx: float
	var dy: float
	var t: float
	for p in number_of_points:
		t = t_of_p(p)
		
	return curve
	
func y_of_t(t:float) -> float:
	var p1: float = v * sa * t
	var p2: float = 0.5 * g * pow(t,2)
	return p1 - p2
	
func t_of_p(p:int) -> float:
	return pow((p/number_of_points) - peak_ratio, 2)
