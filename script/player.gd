extends Actor

@export var speed := 500.0
@export var gun_scene :PackedScene
@export var mining_equipment_scene :PackedScene

@onready var gun := gun_scene.instantiate()
@onready var mining_equipment := mining_equipment_scene.instantiate()

var current_equipment

func _ready() -> void:
	#gun.position = $EquipmentAnglePoint.position
	#add_child(gun)
	add_child(mining_equipment)
	current_equipment = mining_equipment

func _physics_process(delta: float) -> void:
	velocity = speed * Input.get_vector("left","right","up","down")
	move_and_slide()
	rotate_equipment()

func rotate_equipment() -> void:
	var mousePos := get_local_mouse_position()
	current_equipment.rotation = mousePos.angle()	
	current_equipment.position = 	mousePos.normalized() \
					* abs(current_equipment.get_node("AnglePoint").position.x) \
					+ $EquipmentAnglePoint.position

#TODO change equipment

