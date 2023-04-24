extends CharacterBody2D

class_name Player

@export var speed := 500.0
@export var weapon_scene :PackedScene
@export var mining_equipment_scene :PackedScene
@export var projectile_scene :PackedScene

@onready var equipment_angle_point :Vector2 = $EquipmentAnglePoint.position
@onready var gun := weapon_scene.instantiate()
@onready var mining_equipment := mining_equipment_scene.instantiate()

@onready var inputComponent = PlayerInputComponent.new()

var current_equipment: Equipment

func _ready() -> void:
	gun.position = $EquipmentAnglePoint.position
	add_child(gun)
	mining_equipment.position = $EquipmentAnglePoint.position
	add_child(mining_equipment)
	mining_equipment.set_physics_process(false)
	mining_equipment.visible = false
	
	current_equipment = gun


func _physics_process(delta: float) -> void:
	velocity = speed * Input.get_vector("left","right","up","down")
	inputComponent.update(self)
	current_equipment.update(self)
			
	move_and_slide()


func change_equipment(equipment) -> void:
	current_equipment = equipment

func use_equipment() -> void:
	current_equipment.act(self)
