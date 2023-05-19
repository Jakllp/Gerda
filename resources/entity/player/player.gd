extends Entity

class_name Player

@export var weapon_scene :PackedScene
@export var mining_equipment_scene :PackedScene

@onready var equipment_angle_point :Vector2 = $EquipmentAnglePoint.position
@onready var weapon := weapon_scene.instantiate()
@onready var mining_equipment := mining_equipment_scene.instantiate()

@onready var inputComponent = PlayerInputComponent.new()

var current_equipment: Equipment

func _ready() -> void:
	super._ready()
	weapon.position = $EquipmentAnglePoint.position
	add_child(weapon)
	mining_equipment.position = $EquipmentAnglePoint.position
	add_child(mining_equipment)
	mining_equipment.visible = false
	
	current_equipment = weapon


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	inputComponent.update(self)
	
	if direction.length() > 0 and not $SubViewportContainer/SubViewport/AnimatedSprite2D.is_playing():
		$SubViewportContainer/SubViewport/AnimatedSprite2D.play("walk")
	else:
		$SubViewportContainer/SubViewport/AnimatedSprite2D.stop()
	
	current_equipment.update(self)


func change_equipment(equipment) -> void:
	current_equipment.visible = false
	current_equipment = equipment
	current_equipment.visible = true


func use_equipment() -> void:
	current_equipment.act(self)
