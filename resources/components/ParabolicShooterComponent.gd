extends Marker2D

class_name ParabolicShooter

## The projectile to shoot
@export var projectile_scene: PackedScene
## manipulate the height of the peak point
@export var peak_factor: float = 2
## Number of points the Path2D curve gets fed
var number_of_points = 50.0
## The targeted position
var target: Vector2
## velocity for curve calculations
var velocity: float
## gravity for curve calculations
var gravity: float = 10.0
## Shooting angle relative to Vector2.RIGHT
var alpha

func shoot(target: Vector2) -> void:
	# add some spacing (18) to target the players feet
	self.target = target - global_position + Vector2(0,18)
	var p: ParabolicProjectile = projectile_scene.instantiate()
	p.transform = global_transform
	p.curve = calculate_trajectory()
	p.alpha = alpha
	get_node("/root/GameWorld/TileMap/Projectiles").add_child(p)
	
func calculate_trajectory() -> Curve2D:
	var dot = Vector2.RIGHT.dot(target.normalized())
	alpha = PI/2 - PI/(4+peak_factor) * dot
	
	velocity = sqrt((gravity * pow(target.x,2)) / (2 * pow(cos(alpha),2) * (tan(alpha) * target.x + target.y)))
	
	var curve = Curve2D.new()
	
	var x: float = 0
	var y: float = 0
	var point = Vector2(x, y)
	for p in number_of_points:
		x = p/number_of_points * target.x
		y = y_of_x(x) if target.x != 0 else p/number_of_points * target.y
		point = Vector2(x,y)
		curve.add_point(point)
	
	return curve
	
func y_of_x(x:float) -> float:
	return -1.0 * x * (tan(alpha) - ((gravity * x) / (2 * pow(cos(alpha),2) * velocity*velocity)))
	
